import os
import json
from flask import Flask, request, jsonify

# ==============================================================================
# 1. Application Initialization
# ==============================================================================

# Create the Flask application object.
app = Flask(__name__)

# Configuration Check: Get the port assigned by Cloud Run (default is 8080).
PORT = int(os.environ.get("PORT", 8080))
HOST = "0.0.0.0"

# ==============================================================================
# 2. Health Check Endpoint (For Deployment Verification)
# ==============================================================================

@app.route('/health', methods=['GET'])
def health_check():
    """
    Standard health check endpoint. 
    Cloud Run uses this implicitly or explicitly to know the container is ready.
    """
    return jsonify({
        "status": "OK",
        "service": "Chatbot Backend (Test Mode)",
        "message": "Gunicorn and Flask are running correctly."
    }), 200


# ==============================================================================
# 3. Main Chatbot Mock Endpoint
# ==============================================================================

@app.route('/chat', methods=['POST'])
def handle_chat_request():
    """
    Mocks the main chatbot processing logic without connecting to any database.
    It simply echoes the user's message.
    """
    
    # Check if the request contains valid JSON data
    if not request.is_json:
        # Returns a 400 Bad Request if the payload is not JSON
        return jsonify({"error": "Missing JSON payload."}), 400

    data = request.get_json()
    user_message = data.get('message', 'No message provided.')
    session_id = data.get('session_id', 'TEST-SESSION-123')
    
    
    # --- CORE MOCK LOGIC ---
    
    # Simulate processing time (optional, for realistic testing)
    # import time; time.sleep(0.5) 
    
    # Mock AI response
    ai_response = f"TEST MOCK RESPONSE: I successfully received your message in Cloud Run: '{user_message}'"
    
    # --- END MOCK LOGIC ---


    # Send the mock response back to the frontend
    return jsonify({
        "response": ai_response,
        "session_id": session_id,
        "mode": "Test"
    }), 200

# ==============================================================================
# 4. Entry Point (Only for local testing, Gunicorn runs 'app' directly)
# ==============================================================================

if __name__ == "__main__":
    # This block runs only when executing the script directly (e.g., python app.py)
    # Gunicorn bypasses this and executes 'app' directly.
    print(f"🚀 Starting server locally on {HOST}:{PORT}")
    app.run(host=HOST, port=PORT, debug=True)
