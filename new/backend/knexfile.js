const path = require('path');

module.exports = {
    development: {
      client: 'mysql2',
      migrations: {
        directory: path.resolve(__dirname, './src/migrations') // PATH DIKOREKSI DI SINI
      },
      connection: {
        host: 'dbpplg.smkn4bogor.sch.id',
        user: 'pplg',
        password: 'adminpplg2025!',
        database: 'bia_perpusbogor_2025',
        port: 6093,
      },
      // migrations: {
      //   directory: './src/migrations' // Sesuaikan path ini
      // },
    },
  };