import { Router } from "express";
import { AuthMiddleware } from "../middleware/auth.verify.js";
import { HistoryBorrowingsController } from "../controllers/history-borrowings.controller.js";

export class HistoryBorrowingsRouter {
  router;
  historyBorrowingsController;
  authMiddleware;

  constructor() {
    this.router = Router();
    this.historyBorrowingsController = new HistoryBorrowingsController();
    this.authMiddleware = new AuthMiddleware();
    this.initializeRoutes();
  }

  initializeRoutes() {
    this.router.get(
      "/",
      this.historyBorrowingsController.getHistoryBorrowings,
      this.authMiddleware.verifyToken
    );

    this.router.get(
      "/:id",
      this.historyBorrowingsController.getHistoryBorrowingById,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/create",
      this.historyBorrowingsController.createHistoryBorrowing,
      this.authMiddleware.checkRole('admin')
    );

    this.router.post(
      "/update/:id",
      this.historyBorrowingsController.updateHistoryBorrowing,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/delete/:id",
      this.historyBorrowingsController.deleteHistoryBorrowing,
      this.authMiddleware.checkRole('admin')
    );
  }

  getRouter() {
    return this.router;
  }
}

