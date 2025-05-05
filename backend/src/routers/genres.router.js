import { Router } from "express";
import { AuthMiddleware } from "../middleware/auth.verify.js";
import { GenresController } from "../controllers/genres.controller.js";

export class GenresRouter {
  router;
  genresController;
  authMiddleware;

  constructor() {
    this.router = Router();
    this.genresController = new GenresController();
    this.authMiddleware = new AuthMiddleware();
    this.initializeRoutes();
  }

  initializeRoutes() {
    this.router.get(
      "/",
      this.genresController.getGenres,
      this.authMiddleware.verifyToken
    );

    this.router.get(
      "/:id",
      this.genresController.getGenreById,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/create",
      this.genresController.createGenres,
      this.authMiddleware.checkRole('admin')
    );

    this.router.post(
      "/update/:id",
      this.genresController.updateGenres,
      this.authMiddleware.verifyToken
    );

    this.router.post(
      "/delete/:id",
      this.genresController.deleteGenre,
      this.authMiddleware.checkRole('admin')
    );
  }

  getRouter() {
    return this.router;
  }
}

