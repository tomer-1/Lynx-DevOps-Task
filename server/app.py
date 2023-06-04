from flask import Flask, jsonify
from sqlalchemy import create_engine

from settings import DB_URI


def create_app():
    app = Flask(__name__)

    db_engine = create_engine(DB_URI)

    # Create items table if it doesn't exist
    db_engine.execute(
        """
        CREATE TABLE IF NOT EXISTS items (
            name TEXT NOT NULL
        )
        """
    )

    # Insert an item if there are no items
    db_engine.execute(
        """
        INSERT INTO items (name)
        SELECT 'Item 1'
        WHERE NOT EXISTS (SELECT * FROM items)
        """
    )

    @app.route('/items')
    def get_items():
        items = db_engine.execute(
            """
            SELECT * FROM items
            """
        ).fetchall()

        return jsonify([dict(item) for item in items])

    return app
