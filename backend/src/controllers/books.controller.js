import connection from "../services/db.js";
import { hashPass } from "../helpers/hashpassword.js";

export class BooksController {
  async getBooks (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM books';
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

  async getBookById (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM books WHERE book_id = ?';
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

  async createBook (req, res) {
    try {
      const { 
        code,
        title,
        author,
        publisher,
        year,
        pages,
        genre_id,
        floor,
        shelf,
        cover_url,
        description,
      } = req.body

      const sqlCreateData = 'INSERT INTO books (code, title, author, publisher, year, pages, genre_id, floor, shelf, cover_url, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

      connection.query(sqlCreateData, [code, title, author, publisher, year, pages, genre_id, floor, shelf, cover_url, description], (err, result) => {
        if (err) res.status(500).json({"error": err})
        if (!result) {
          return res.status(400).json({ message: "User not found" });
        }

        
        res.status(201).json({
          status: 201,
          message: 'Berhasil membuat buku!',
          data: {
            book_id: result.insertId, // Mengambil ID buku yang baru dibuat
            code,
            title,
            author,
            publisher,
            year,
            pages,
            genre_id,
            floor,
            shelf,
            cover_url,
            description,
          }
        })
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }

  async updateBook (req, res) {
    try {
      const {
        code,
        title,
        author,
        publisher,
        year,
        pages,
        genre_id,
        floor,
        shelf,
        cover_url,
        description,
      } = req.body;

      const bookId = req.params.id; // Asumsi ID buku ada di params

      const sqlUpdateData = 'UPDATE books SET code = ?, title = ?, author = ?, publisher = ?, year = ?, pages = ?, genre_id = ?, floor = ?, shelf = ?, cover_url = ?, description = ? WHERE book_id = ?';

      connection.query(sqlUpdateData, [code, title, author, publisher, year, pages, genre_id, floor, shelf, cover_url, description, bookId], (err, result) => {
        if (err) res.status(500).json({"error": err});
        if (result.affectedRows === 0) {
          return res.status(404).json({ message: "Buku tidak ditemukan atau tidak ada perubahan yang dilakukan" });
        }
        res.status(200).json({ status: 200, message: 'Berhasil memperbarui data buku!', data: result });
      });
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }

  async deleteBook (req, res) {
    try {
      const sqlDeleteData = 'DELETE FROM books WHERE book_id = ?';
      connection.query(sqlDeleteData, [req.params.id], (err, result) => {
        res.json({ status: 200, message: 'success remove book', data: result })
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }
}
