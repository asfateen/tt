from app import create_app

app = create_app()

if __name__ == '__main__':
    app.run(
        debug=True,
        host='0.0.0.0',  # Allow external connections
        port=8000
    )