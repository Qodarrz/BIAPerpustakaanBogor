import { Router } from "express";
import { AuthMiddleware } from "../middleware/auth.verify.js";
import { CategoriesController } from "../controllers/categories.controller.js";

export class CategoriesRouter {
  router;
  categoriesController;
  authMiddleware;

  constructor() {
    this.router = Router();
    this.categoriesController = new CategoriesController();
    this.authMiddleware = new AuthMiddleware();
    this.initializeRoutes();
  }

  initializeRoutes() {
    this.router.get(
      "/",
      this.categoriesController.getCategories,
      this.authMiddleware.verifyToken
    );

    this.router.get(
      "/:id",
      this.categoriesController.getCategorieById,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/create",
      this.categoriesController.createCategorie,
      this.authMiddleware.checkRole('admin')
    );

    this.router.post(
      "/update/:id",
      this.categoriesController.updateCategorie,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/delete/:id",
      this.categoriesController.deleteCategorie,
      this.authMiddleware.checkRole('admin')
    );
  }

  getRouter() {
    return this.router;
  }
}

