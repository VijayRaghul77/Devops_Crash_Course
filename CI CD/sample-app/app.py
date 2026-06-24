from http.server import BaseHTTPRequestHandler, HTTPServer
import json
import os

HOST = "0.0.0.0"
PORT = int(os.getenv("PORT", 8000))

class Handler(BaseHTTPRequestHandler):
    def _send_json(self, status, payload):
        data = json.dumps(payload).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path == "/health":
            self._send_json(200, {"status": "ok", "service": "ci-cd-sample"})
        elif self.path == "/":
            self._send_json(200, {"message": "CI/CD sample app is running"})
        else:
            self._send_json(404, {"error": "not found"})

    def log_message(self, format, *args):
        return

if __name__ == "__main__":
    server = HTTPServer((HOST, PORT), Handler)
    print(f"Running on http://{HOST}:{PORT}")
    server.serve_forever()
