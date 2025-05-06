import { Router } from "express";
import { AuthMiddleware } from "../middleware/auth.verify.js";
import { ProductsController } from "../controllers/products.controller.js";

export class ProductsRouter {
  router;
  productsController;
  authMiddleware;

  constructor() {
    this.router = Router();
    this.productsController = new ProductsController();
    this.authMiddleware = new AuthMiddleware();
    this.initializeRoutes();
  }

  initializeRoutes() {
    this.router.get(
      "/",
      this.productsController.getUsers,
      this.authMiddleware.verifyToken
    );

    this.router.get(
      "/:id",
      this.productsController.getUserById,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/create",
      this.productsController.createUsers,
      this.authMiddleware.checkRole('admin')
    );

    this.router.post(
      "/update/:id",
      this.productsController.updateUsersPublic,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/delete/:id",
      this.productsController.deleteUsers,
      this.authMiddleware.checkRole('admin')
    );
  }

  getRouter() {
    return this.router;
  }
}

