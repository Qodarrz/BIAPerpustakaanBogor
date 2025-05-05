/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = async function(knex) {
  // Users table
  await knex.schema
    .dropTableIfExists("users")
    .createTable('users', (table) => {
      table.increments('user_id').primary();
      table.string('username').notNullable().unique();
      table.string('first_name').nullable();
      table.string('last_name').nullable();
      table.text('avatar').defaultTo(null);
      table.string('email').notNullable().unique();
      table.bigInteger('phone').unique().nullable();
      table.enu('role', ['guest', 'admin']).notNullable();
      table.string('password').notNullable();
      table.text('password_reset_token').nullable();
      table.text('google_id').nullable();
      table.text('verify_email_token').nullable();
      table.boolean('status').notNullable().defaultTo(true);
      table.timestamp('created_at').defaultTo(knex.fn.now());
      table.timestamp('updated_at').defaultTo(knex.fn.now());
    });

  // Genres table (assuming it's needed for books)
  await knex.schema
    .dropTableIfExists("genres")
    .createTable('genres', (table) => {
      table.increments('genre_id').primary();
      table.string('name').notNullable().unique();
      table.timestamp('created_at').defaultTo(knex.fn.now());
      table.timestamp('updated_at').defaultTo(knex.fn.now());
    });

  // Categories table (assuming it's needed for products)
  await knex.schema
    .dropTableIfExists("categories")
    .createTable('categories', (table) => {
      table.increments('category_id').primary();
      table.string('name').notNullable().unique();
      table.timestamp('created_at').defaultTo(knex.fn.now());
      table.timestamp('updated_at').defaultTo(knex.fn.now());
    });

  // Books table
  await knex.schema
    .dropTableIfExists("books")
    .createTable('books', (table) => {
      table.increments('book_id').primary(); // Menggunakan book_id sebagai PK yang lebih spesifik
      table.string('code', 20).notNullable().unique();
      table.string('title').notNullable();
      table.string('author');
      table.string('publisher');
      table.string('year');
      table.integer('pages');
      table.integer('genre_id').unsigned().references('genre_id').inTable('genres');
      table.integer('floor');
      table.string('shelf', 10);
      table.text('cover_url');
      table.text('description');
      table.boolean('is_active').defaultTo(true);
      table.timestamp('created_at').defaultTo(knex.fn.now());
      table.timestamp('updated_at').defaultTo(knex.fn.now());
    });

  // Products table
  await knex.schema
    .dropTableIfExists("products")
    .createTable('products', (table) => {
      table.increments('product_id').primary(); // Menggunakan product_id sebagai PK yang lebih spesifik
      table.string('code', 20).notNullable().unique();
      table.string('name').notNullable();
      table.text('description');
      table.decimal('price', 10, 2).notNullable();
      table.string('unit', 20);
      table.integer('stock').notNullable().defaultTo(0);
      table.date('expired_at').nullable();
      table.integer('category_id').unsigned().references('category_id').inTable('categories');
      table.integer('floor');
      table.string('shelf', 10);
      table.text('image_url');
      table.boolean('is_active').defaultTo(true);
      table.timestamp('created_at').defaultTo(knex.fn.now());
      table.timestamp('updated_at').defaultTo(knex.fn.now());
    });

    // Borrowings table
    await knex.schema
    .dropTableIfExists("borrowings")
    .createTable('borrowings', (table) => {
      table.increments('borrowing_id').primary();
      table.integer('book_id').unsigned().notNullable().references('book_id').inTable('books').onDelete('RESTRICT').onUpdate('CASCADE');
      table.integer('user_id').unsigned().notNullable().references('user_id').inTable('users').onDelete('RESTRICT').onUpdate('CASCADE');
      table.timestamp('borrow_date').defaultTo(knex.fn.now());
      table.date('return_date');
      table.timestamp('actual_return_date').nullable();
      table.text('reason').nullable();
      table.enu('borrowing_status', ['borrowed', 'returned', 'overdue']).notNullable().defaultTo('borrowed');
      table.text('notes').nullable();
      table.timestamp('created_at').defaultTo(knex.fn.now());
      table.timestamp('updated_at').defaultTo(knex.fn.now());
    });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */

exports.down = async function(knex) {
  await knex.schema.dropTableIfExists('borrowings');
  await knex.schema.dropTableIfExists('products');
  await knex.schema.dropTableIfExists('books');
  await knex.schema.dropTableIfExists('categories');
  await knex.schema.dropTableIfExists('genres');
  await knex.schema.dropTableIfExists('users');
};