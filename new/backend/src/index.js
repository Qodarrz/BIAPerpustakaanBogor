import express from "express";
import cors from "cors";
import { AuthRouter } from "./routers/auth.router.js";
import { UsersRouter } from "./routers/users.router.js";
import { BooksRouter } from "./routers/books.router.js";

import dotenv from "dotenv";
import { ProductsRouter } from "./routers/products.router.js";
import { CategoriesRouter } from "./routers/categories.router.js";
import { GenresRouter } from "./routers/genres.router.js";
import { BorrowingsRouter } from "./routers/borrowings.router.js";
dotenv.config();

const PORT = process.env.PORT || 5000;
const base_url_fe = process.env.FE_URL;

const app = express();

app.use(cors({
  origin: "*",
  credentials: true,
  methods: ["GET", "POST", "PUT", "DELETE", "PATCH"],
  allowedHeaders: ["Content-Type", "Authorization"],
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const authRouter = new AuthRouter().getRouter();
const usersRouter = new UsersRouter().getRouter();
const borrowingsRouter = new BorrowingsRouter().getRouter();
const booksRouter = new BooksRouter().getRouter();
const productsRouter = new ProductsRouter().getRouter();
const categoriesRouter = new CategoriesRouter().getRouter();
const genresRouter = new GenresRouter().getRouter();
app.use("/api/auth", authRouter);
app.use("/api/users", usersRouter);
app.use("/api/books", booksRouter);
app.use("/api/borrowings", borrowingsRouter);
app.use("/api/categories", categoriesRouter);
app.use("/api/genres", genresRouter);
app.use("/api/products", productsRouter); // ini belum dibuat controller nya

// Route home
app.get("/", (req, res) => {
  res.status(200).json({ server: 'on', message: 'server is online.' });
});
// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server backend is running on http://localhost:${PORT}`);
});