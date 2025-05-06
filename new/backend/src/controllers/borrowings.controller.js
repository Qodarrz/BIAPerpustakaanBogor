import connection from "../services/db.js";
import { hashPass } from "../helpers/hashpassword.js";

export class BorrowingsController {
  async getBorrowings (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM borrowings';
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

  async getBorrowingById (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM borrowings WHERE borrowing_id = ?';
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

  async createBorrowing(req, res) {
    try {
      const {
        book_id,
        user_id,
        return_date,
        reason,
        notes
      } = req.body;
  
       // Validasi input dasar
      if (!book_id || !user_id) {
        return res.status(400).json({ message: "book_id dan user_id harus diisi." });
      }

      // Cek keberadaan buku
      const checkBookQuery = 'SELECT book_id FROM books WHERE book_id = ?';
      const [bookRows] = await connection.execute(checkBookQuery, [book_id]);

      if (bookRows.length === 0) {
        return res.status(400).json({ message: "Buku dengan book_id tersebut tidak ditemukan." });
      }

      // Cek keberadaan user
      const checkUserQuery = 'SELECT user_id FROM users WHERE user_id = ?';
      const [userRows] = await connection.execute(checkUserQuery, [user_id]);

      if (userRows.length === 0) {
        return res.status(400).json({ message: "Pengguna dengan user_id tersebut tidak ditemukan." });
      }

      const sqlCreateData = 'INSERT INTO borrowings (book_id, user_id, return_date, reason, notes) VALUES (?, ?, ?, ?, ?)';
  
      connection.query(sqlCreateData, [book_id, user_id, return_date, reason, notes], (err, result) => {
        if (err) {
          console.error("Error creating borrowing:", err);
          return res.status(500).json({ error: err });
        }
        if (result.affectedRows === 0) {
          return res.status(400).json({ message: "Gagal membuat peminjaman" });
        }
  
        const borrowingId = result.insertId;
  
        res.status(201).json({
          status: 201,
          message: 'Berhasil membuat peminjaman!',
          data: {
            borrowing_id: borrowingId,
            book_id,
            user_id,
            return_date,
            reason,
            notes
          }
        });
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error occurred";
      console.error("Error in createBorrowing:", error);
      return res.status(500).json({ error: message });
    }
  }

  async updateBorrowing(req, res) {
    try {
      const {
        book_id,
        user_id,
        return_date,
        actual_return_date,
        reason,
        borrowing_status,
        notes
      } = req.body;
  
      const borrowingId = req.params.id;
  
      // Validasi input dasar untuk ID peminjaman
      if (!borrowingId) {
        return res.status(400).json({ message: "borrowing_id harus diisi." });
      }
  
      // Cek keberadaan peminjaman yang akan diupdate
      const checkBorrowingQuery = 'SELECT borrowing_id FROM borrowings WHERE borrowing_id = ?';
      connection.query(checkBorrowingQuery, [borrowingId], (errCheck, resultCheck) => {
        if (errCheck) {
          console.error("Error checking borrowing:", errCheck);
          return res.status(500).json({ error: errCheck });
        }
        if (resultCheck.length === 0) {
          return res.status(404).json({ message: `Peminjaman dengan ID ${borrowingId} tidak ditemukan.` });
        }
  
        const sqlUpdateData = 'UPDATE borrowings SET book_id = ?, user_id = ?, return_date = ?, actual_return_date = ?, reason = ?, borrowing_status = ?, notes = ? WHERE borrowing_id = ?';
  
        connection.query(sqlUpdateData, [
          book_id,
          user_id,
          return_date,
          actual_return_date,
          reason,
          borrowing_status,
          notes,
          borrowingId
        ], (errUpdate, resultUpdate) => {
          if (errUpdate) {
            console.error("Error updating borrowing:", errUpdate);
            return res.status(500).json({ error: errUpdate });
          }
          if (resultUpdate.affectedRows === 0) {
            return res.status(200).json({ message: "Tidak ada perubahan yang dilakukan pada data peminjaman." });
          }
  
          res.status(200).json({
            status: 200,
            message: `Berhasil memperbarui data peminjaman dengan ID ${borrowingId}!`,
            data: {
              borrowing_id: borrowingId,
              book_id,
              user_id,
              return_date,
              actual_return_date,
              reason,
              borrowing_status,
              notes
            }
          });
        });
      });
    } catch (error) {
      console.error("Error in updateBorrowing:", error);
      return res.status(500).json({ error: error.message || "Unknown error occurred" });
    }
  }

  async deleteBorrowing (req, res) {
    try {
      const sqlDeleteData = 'DELETE FROM borrowings WHERE borrowing_id = ?';
      connection.query(sqlDeleteData, [req.params.id], (err, result) => {
        return res.status(200).json({ status: 200, message: 'success remove borrowing', data: result })
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }
}
