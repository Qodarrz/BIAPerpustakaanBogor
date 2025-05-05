import { Router } from "express";
import { AuthMiddleware } from "../middleware/auth.verify.js";
import { BorrowingsController } from "../controllers/borrowings.controller.js";

export class BorrowingsRouter {
  router;
  borrowingsController;
  authMiddleware;

  constructor() {
    this.router = Router();
    this.borrowingsController = new BorrowingsController();
    this.authMiddleware = new AuthMiddleware();
    this.initializeRoutes();
  }

  initializeRoutes() {
    this.router.get(
      "/",
      this.borrowingsController.getBorrowings,
      this.authMiddleware.verifyToken
    );

    this.router.get(
      "/:id",
      this.borrowingsController.getBorrowingById,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/create",
      this.borrowingsController.createBorrowing,
      this.authMiddleware.checkRole('admin')
    );

    this.router.post(
      "/update/:id",
      this.borrowingsController.updateBorrowing,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/delete/:id",
      this.borrowingsController.deleteBorrowing,
      this.authMiddleware.checkRole('admin')
    );
  }

  getRouter() {
    return this.router;
  }
}

