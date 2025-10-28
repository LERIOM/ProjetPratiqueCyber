#!/usr/bin/env python3
from http.server import HTTPServer, BaseHTTPRequestHandler

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        # toujours répondre 200 OK pour n'importe quelle requête
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.end_headers()
        self.wfile.write(b"ok\n")

    # pas de logs console spam
    def log_message(self, *_):
        return

if __name__ == "__main__":
    HTTPServer(("0.0.0.0", 80), Handler).serve_forever()