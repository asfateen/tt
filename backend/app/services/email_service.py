import os
from datetime import datetime, timedelta
from dotenv import load_dotenv
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from ..models import OTP
from .. import db

load_dotenv()

class EmailService:
    def __init__(self):
        self.smtp_host = os.getenv('SMTP_HOST')
        self.smtp_port = int(os.getenv('SMTP_PORT'))
        self.smtp_user = os.getenv('SMTP_USER')
        self.smtp_password = os.getenv('SMTP_PASSWORD')

    def send_otp_email(self, email, otp):
        msg = MIMEMultipart()
        msg['Subject'] = 'Your Batee5 Verification Code'
        msg['From'] = self.smtp_user
        msg['To'] = email

        html = f"""
        <html>
            <body style="font-family: Arial, sans-serif;">
                <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                    <h2 style="color: #006400;">Your Verification Code</h2>
                    <p>Hello,</p>
                    <p>Your verification code for Batee5 is:</p>
                    <div style="background-color: #f5f5f5; padding: 10px; text-align: center; font-size: 24px; letter-spacing: 5px;">
                        <strong>{otp}</strong>
                    </div>
                    <p>This code will expire in 10 minutes.</p>
                    <p>If you didn't request this code, please ignore this email.</p>
                    <p>Best regards,<br>The Batee5 Team</p>
                </div>
            </body>
        </html>
        """
        
        msg.attach(MIMEText(html, 'html'))

        try:
            with smtplib.SMTP(self.smtp_host, self.smtp_port) as server:
                server.starttls()
                server.login(self.smtp_user, self.smtp_password)
                server.send_message(msg)
                
                # Store OTP in database
                otp_record = OTP(
                    email=email,
                    otp=otp,
                    expires_at=datetime.utcnow() + timedelta(minutes=10)
                )
                db.session.add(otp_record)
                db.session.commit()
                
                return True
        except Exception as e:
            print(f"Failed to send email: {str(e)}")
            return False

    def verify_otp(self, email, otp):
        # Find the most recent unused OTP for this email
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