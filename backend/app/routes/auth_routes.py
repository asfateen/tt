from flask import Blueprint, request, jsonify
from ..models import User
from ..services.email_service import EmailService
from ..services.auth_service import (
    create_user,
    verify_otp,
    generate_otp,
    hash_password
)
from .. import db

auth = Blueprint('auth', __name__)
email_service = EmailService()

@auth.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get('email')
    name = data.get('name')
    
    if not email or not name:
        return jsonify({'error': 'Email and name are required'}), 400
    
    # Check if user already exists
    existing_user = User.query.filter_by(email=email).first()
    if existing_user:
        return jsonify({'error': 'Email already registered'}), 400
        
    # Create unverified user
    user = User(email=email, name=name, password=hash_password('temp'))
    db.session.add(user)
    db.session.commit()
    
    # Generate and send OTP
    otp = generate_otp()
    if email_service.send_otp_email(email, otp):
        return jsonify({'message': 'OTP sent successfully'}), 200
    
    # Rollback user creation if OTP sending fails
    db.session.delete(user)
    db.session.commit()
    return jsonify({'error': 'Failed to send OTP'}), 500

@auth.route('/verify-otp', methods=['POST'])
def verify():
    data = request.get_json()
    email = data.get('email')
    otp = data.get('otp')
    
    if not email or not otp:
        return jsonify({'error': 'Email and OTP are required'}), 400
    
    if verify_otp(email, otp):
        # Update user verification status
        user = User.query.filter_by(email=email).first()
        if user:
            user.verified = True
            db.session.commit()
            return jsonify({'message': 'OTP verified successfully'}), 200
    
    return jsonify({'error': 'Invalid OTP'}), 400

@auth.route('/set-password', methods=['POST'])
def set_password():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    
    if not email or not password:
        return jsonify({'error': 'Email and password are required'}), 400
    
    user = User.query.filter_by(email=email, verified=True).first()
    if not user:
        return jsonify({'error': 'User not found or not verified'}), 404
    
    user.password = hash_password(password)
    db.session.commit()
    
    return jsonify({'message': 'Password set successfully'}), 200