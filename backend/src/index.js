import express from "express";
import cors from "cors";
import { AuthRouter } from "./routers/auth.router.js";
import { UsersRouter } from "./routers/users.router.js";

import dotenv from "dotenv";
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
app.use("/api/auth", authRouter);
app.use("/api/users", usersRouter);
app.use("/api/products", usersRouter);
app.use("/api/books", usersRouter);
app.use("/api/categories", usersRouter);
app.use("/api/genres", usersRouter);

// Route home
app.get("/", (req, res) => {
  res.status(200).json({ server: 'on', message: 'server is online.' });
});
// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server backend is running on http://localhost:${PORT}`);
});