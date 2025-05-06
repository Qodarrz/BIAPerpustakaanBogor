import { Router } from "express";
import { AuthMiddleware } from "../middleware/auth.verify.js";
import { BooksController } from "../controllers/books.controller.js";

export class BooksRouter {
  router;
  booksController;
  authMiddleware;

  constructor() {
    this.router = Router();
    this.booksController = new BooksController();
    this.authMiddleware = new AuthMiddleware();
    this.initializeRoutes();
  }

  initializeRoutes() {
    this.router.get(
      "/",
      this.authMiddleware.verifyToken,
      this.booksController.getBooks,
    );

    this.router.get(
      "/:id",
      this.authMiddleware.verifyToken,
      this.booksController.getBookById,
    );

    this.router.post(
      "/create",
      this.booksController.createBook,
      this.authMiddleware.checkRole('admin')
    );
    
    this.router.post(
      "/update/:id",
      this.authMiddleware.checkRole('admin'),
      this.booksController.updateBook,
    );

    this.router.post(
      "/delete/:id",
      this.authMiddleware.checkRole('admin'),
      this.booksController.deleteBook,
    );
  }

  getRouter() {
    return this.router;
  }
}

