import connection from "../services/db.js";
import { hashPass } from "../helpers/hashpassword.js";

export class CategoriesController {
  async getCategories (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM categories';
      connection.query(sqlDataGet, (err, result) => {
        if (err) res.json({"error": err})
        if (result) {
          const sanitizedData = result.map(({ password, ...user }) => user);
    
          res.json({ status: 200, message: 'success get data', data: sanitizedData })
        }
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }

  async getCategorieById (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM categories WHERE categorie_id = ?';
      connection.query(sqlDataGet, [req.params.id ?? 1], (err, result) => {
        if (err) res.json({"error": err})
        if (result) {
          const sanitizedData = result.map(({ password, ...user }) => user);
    
          res.json({ status: 200, message: 'success get data', data: sanitizedData })
        }
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }

  async createCategorie(req, res) {
    try {
      const { name } = req.body;
  
      const sqlCreateData = 'INSERT INTO categories (name) VALUES (?)';
  
      connection.query(sqlCreateData, [name], (err, result) => {
        if (err) {
          console.error("Error creating category:", err);
          return res.status(500).json({ error: err });
        }
        if (result.affectedRows === 0) {
          return res.status(400).json({ message: "Gagal membuat kategori" });
        }
  
        const categoryId = result.insertId;
  
        res.status(201).json({
          status: 201,
          message: 'Berhasil membuat kategori!',
          data: {
            category_id: categoryId,
            name,
          }
        });
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error occurred";
      console.error("Error in createCategorie:", error);
      return res.status(500).json({ error: message });
    }
  }

  async updateCategorie(req, res) {
    try {
      const { name } = req.body;
      const categoryId = req.params.id;
  
      if (!categoryId) {
        return res.status(400).json({ message: "category_id harus diisi." });
      }
  
      const sqlUpdateData = 'UPDATE categories SET name = ? WHERE category_id = ?';
  
      connection.query(sqlUpdateData, [name, categoryId], (err, result) => {
        if (err) {
          console.error("Error updating category:", err);
          return res.status(500).json({ error: err });
        }
        if (result.affectedRows === 0) {
          return res.status(404).json({ message: `Kategori dengan ID ${categoryId} tidak ditemukan atau tidak ada perubahan.` });
        }
  
        res.status(200).json({
          status: 200,
          message: `Berhasil memperbarui kategori dengan ID ${categoryId}!`,
          data: {
            category_id: categoryId,
            name,
          }
        });
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error occurred";
      console.error("Error in updateCategorie:", error);
      return res.status(500).json({ error: message });
    }
  }

  async deleteCategorie (req, res) {
    try {
      const sqlDeleteData = 'DELETE FROM categories WHERE categorie_id = ?';
      connection.query(sqlDeleteData, [req.params.id], (err, result) => {
        return res.status(200).json({ status: 200, message: 'success remove user', data: result })
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }
}
