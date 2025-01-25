from datetime import datetime
from ..models import OTP
from .. import db

def cleanup_expired_otps():
    """Delete expired OTPs older than 24 hours"""
    OTP.query.filter(
        OTP.expires_at < datetime.utcnow()
    ).delete()
    db.session.commit()