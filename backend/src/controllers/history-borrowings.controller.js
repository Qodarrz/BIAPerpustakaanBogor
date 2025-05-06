import connection from "../services/db.js";
import { hashPass } from "../helpers/hashpassword.js";

export class HistoryBorrowingsController {
  async getHistoryBorrowings (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM history_borrowing';
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

  async getHistoryBorrowingById (req, res) {
    try {
      const sqlDataGet = 'SELECT * FROM history_borrowing WHERE history_id = ?';
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

  async createHistoryBorrowing(req, res) {
    try {
      const { borrowing_id, actual_return_date, total_books_read, borrowing_status, notes } = req.body;
  
      // Validasi input
      if (!borrowing_id || !actual_return_date || !borrowing_status) {
        return res.status(400).json({ message: "borrowing_id, actual_return_date, dan borrowing_status harus diisi." });
      }
  
      // Cek keberadaan borrowing
      const checkBorrowingQuery = 'SELECT book_id, user_id, borrow_date, return_date FROM borrowings WHERE borrowing_id = ?';
      const [borrowingRows] = await connection.execute(checkBorrowingQuery, [borrowing_id]);
  
      if (borrowingRows.length === 0) {
        return res.status(404).json({ message: "Peminjaman dengan borrowing_id tersebut tidak ditemukan." });
      }
  
      const { book_id, user_id, borrow_date, return_date } = borrowingRows[0];
  
      const sqlCreateData = 'INSERT INTO borrowing_history (borrowing_id, book_id, total_books_read, user_id, borrow_date, return_date, actual_return_date, borrowing_status, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';
  
      connection.query(sqlCreateData, [borrowing_id, book_id, total_books_read, user_id, borrow_date, return_date, actual_return_date, borrowing_status, notes], (err, result) => {
        if (err) {
          console.error("Error creating history borrowing:", err);
          return res.status(500).json({ error: err });
        }
        if (result.affectedRows === 0) {
          return res.status(400).json({ message: "Gagal membuat catatan riwayat peminjaman" });
        }
  
        const historyId = result.insertId;
  
        // Hapus data dari tabel borrowings setelah dipindahkan ke history
        const deleteBorrowingQuery = 'DELETE FROM borrowings WHERE borrowing_id = ?';
        connection.query(deleteBorrowingQuery, [borrowing_id], (deleteErr) => {
          if (deleteErr) {
            console.error("Error deleting from borrowings:", deleteErr);
            // Tidak mengembalikan error ke user, tapi log error
          }
          res.status(201).json({
            status: 201,
            message: 'Berhasil membuat catatan riwayat peminjaman!',
            data: {
              history_id: historyId,
              borrowing_id,
              book_id,
              user_id,
              borrow_date,
              return_date,
              actual_return_date,
              borrowing_status,
              notes
            }
          });
        });
      });
    } catch (error) {
      const message = error instanceof Error ? error.message : "Unknown error occurred";
      console.error("Error in createHistoryBorrowing:", error);
      return res.status(500).json({ error: message });
    }
  }
  
  async updateHistoryBorrowing(req, res) {
      return res.status(405).json({ message: "Method Not Allowed. Riwayat peminjaman tidak dapat diubah." });
  }

  async deleteHistoryBorrowing (req, res) {
    try {
      const sqlDeleteData = 'DELETE FROM history_borrowing WHERE history_id = ?';
      connection.query(sqlDeleteData, [req.params.id], (err, result) => {
        return res.status(200).json({ status: 200, message: 'success remove history borrowing', data: result })
      })
    } catch (error) {
      const message =
        error instanceof Error ? error.message : "Unknown error occurred";
      return res.status(500).json({ error: message });
    }
  }
}
