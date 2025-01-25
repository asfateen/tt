import jwt
import bcrypt
import random
import string
from datetime import datetime, timedelta
from ..models import User, OTP
from .. import db
from .email_service import send_otp_email

SECRET_KEY = 'your-secret-key'  # Move to environment variables

def generate_otp():
    return ''.join(random.choices(string.digits, k=6))

def hash_password(password):
    return bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

def verify_password(password, hashed):
    return bcrypt.checkpw(password.encode('utf-8'), hashed)

def create_user(email, name, password=None):
    """Create a new user with optional password"""
    if password:
        hashed_password = hash_password(password)
    else:
        hashed_password = hash_password('temporary')  # Temporary password
        
    user = User(
        email=email,
        name=name,
        password=hashed_password,
        verified=False
    )
    db.session.add(user)
    db.session.commit()
    return user

def send_verification_otp(email):
    otp = generate_otp()
    # Store OTP with expiration
    otp_record = OTP(
        email=email,
        otp=otp,
        expires_at=datetime.utcnow() + timedelta(minutes=10)
    )
    db.session.add(otp_record)
    db.session.commit()
    
    # Send OTP email
    send_otp_email(email, otp)
    return True

def verify_otp(email, otp):
    """Verify OTP and mark as used if valid"""
    otp_record = OTP.query.filter_by(
        email=email,
        otp=otp,
        used=False
    ).order_by(OTP.created_at.desc()).first()
    
    if not otp_record:
        return False
        
    if otp_record.expires_at < datetime.utcnow():
        return False
        
    otp_record.used = True
    db.session.commit()
    return True

def generate_token(user_id):
    return jwt.encode(
        {
            'user_id': user_id,
            'exp': datetime.utcnow() + timedelta(days=1)
        },
        SECRET_KEY,
        algorithm='HS256'
    )

def get_user_by_email(email):
    """Get user by email"""
    return User.query.filter_by(email=email).first()