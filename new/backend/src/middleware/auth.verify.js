import { responseError } from "../helpers/responseError.js";
import pkg from "jsonwebtoken";
const { decode, TokenExpiredError, verify } = pkg;

import jwt from "jsonwebtoken";
export class AuthMiddleware {
  verifyToken(req, res, next) {
    try {
      // Ambil token dari header Authorization
      const token = req.headers.authorization?.replace("Bearer ", "");

      if (!token) {
        return res.status(403).json({ message: "Access Denied, No Token Provided" });
      }

      // Verifikasi dan decode token
      const user = jwt.verify(token, process.env.SECRET_KEY);

      // Sisipkan user_id dari token ke dalam req.user
      req.user = user; // Misalnya payload token berisi { user_id, email, etc. }

      next(); // Lanjutkan ke route handler (controller)
    } catch (error) {
      return res.status(401).json({ message: "Invalid or Expired Token" });
    }
  }


  verifyExpiredToken(req, res, next) {
    try {
      let token = req.headers.authorization?.replace("Bearer ", "");

      if (!token) throw "Verification Failed";

      const user = verify(token, process.env.SECRET_KEY);

      // Validasi manual token expired
      if (user.exp && Date.now() >= user.exp * 86400) {
        throw new TokenExpiredError(
          "Token expired",
          new Date(user.exp * 86400)
        );
      }

      req.user = { id: user.id, role: user.role };
      next();
    } catch (error) {
      if (error instanceof TokenExpiredError) {
        return res.status(300);
      } else {
        return res.status(200);
      }
    }
  }

  checkRole(role) {
    return (req, res, next) => {
      try {
        const token = req.headers.authorization?.replace("Bearer ", "");

        if (!token) throw "Verification Failed";
        const decoded = decode(token);
        if (typeof decoded !== "string" && decoded && decoded.role === role) {
          next();
        } else {
          throw `You Are Not Authorized! Required role: ${role}`;
        }
      } catch (error) {
        responseError(res, error);
      }
    };
  }

  isSuperAdmin = this.checkRole("super_admin");
  checkStrAdmin = this.checkRole("store_admin");
  checkSuperAdmin = this.checkRole("super_admin");
}
