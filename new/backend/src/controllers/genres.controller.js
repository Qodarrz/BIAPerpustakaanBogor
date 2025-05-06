import connection from "../services/db.js";
import { hashPass } from "../helpers/hashpassword.js";

export class GenresController {
  async getGenres (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM genres';
      connection.query(sqlDataGet, (err, result) => {
        if (err) res.json({"error": err})
        if (result) {
          const sanitizedData = result.map(({ password, ...user }) => user);
    
          return res.status(200).json({ status: 200, message: 'success get data', data: sanitizedData })
        }
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }

  async getGenreById (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM genres WHERE genre_id = ?';
      connection.query(sqlDataGet, [req.params.id ?? 1], (err, result) => {
        if (err) res.json({"error": err})
        if (result) {
          const sanitizedData = result.map(({ password, ...user }) => user);
    
          return res.status(200).json({ status: 200, message: 'success get data', data: sanitizedData })
        }
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }

  async createGenres(req, res) {
    try {
      const { name } = req.body;
  
      const sqlCreateData = 'INSERT INTO genres (name) VALUES (?)';
  
      connection.query(sqlCreateData, [name], (err, result) => {
        if (err) {
          console.error("Error creating genre:", err); // Perbaiki pesan error
          return res.status(500).json({ error: err });
        }
        if (result.affectedRows === 0) {
          return res.status(400).json({ message: "Gagal membuat genre" }); // Perbaiki pesan
        }
  
        const genreId = result.insertId; // Perbaiki nama variabel
  
        res.status(201).json({
          status: 201,
          message: 'Berhasil membuat genre!', // Perbaiki pesan
          data: {
            genre_id: genreId, // Perbaiki nama variabel
            name,
          }
        });
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error occurred";
      console.error("Error in createGenres:", error); // Perbaiki nama fungsi di log
      return res.status(500).json({ error: message });
    }
  }

  async updateGenres(req, res) {
    try {
      const { name } = req.body;
      const genreId = req.params.id; // Perbaiki nama variabel
  
      if (!genreId) {
        return res.status(400).json({ message: "genre_id harus diisi." }); // Perbaiki pesan
      }
  
      const sqlUpdateData = 'UPDATE genres SET name = ? WHERE genre_id = ?'; // Perbaiki nama tabel
  
      connection.query(sqlUpdateData, [name, genreId], (err, result) => {
        if (err) {
          console.error("Error updating genre:", err); // Perbaiki pesan error
          return res.status(500).json({ error: err });
        }
        if (result.affectedRows === 0) {
          return res.status(404).json({ message: `Genre dengan ID ${genreId} tidak ditemukan atau tidak ada perubahan.` }); // Perbaiki pesan
        }
  
        res.status(200).json({
          status: 200,
          message: `Berhasil memperbarui genre dengan ID ${genreId}!`, // Perbaiki pesan
          data: {
            genre_id: genreId, // Perbaiki nama variabel
            name,
          }
        });
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error occurred";
      console.error("Error in updateGenres:", error); // Perbaiki nama fungsi di log
      return res.status(500).json({ error: message });
    }
  }

  async deleteGenre (req, res) {
    try {
      const sqlDeleteData = 'DELETE FROM genres WHERE genre_id = ?';
      connection.query(sqlDeleteData, [req.params.id], (err, result) => {
        return res.status(200).json({ status: 200, message: 'success remove genre', data: result })
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }
}
