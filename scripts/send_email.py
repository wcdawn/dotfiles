#!/usr/bin/python3

import smtplib, ssl
import os

def send_email(from_email, to_email, subject, body, **kwargs):
    port = 465 # for SSL
    password = kwargs.get('password')
    if (password is None):
        password = input('Type your password and press enter: ')

    message_fmt = 'Subject: {:s}\n\n{:s}'
    message = message_fmt.format(subject, body)

    # create a new secure SSL context
    context = ssl.create_default_context()

    with smtplib.SMTP_SSL('smtp.gmail.com', port, context=context) as server:
        server.login(from_email, password)
        server.sendmail(from_email, to_email, message)

def send_email_from_file(from_email, to_email, subject, fname, **kwargs):
    f = open(fname, 'r')
    body = f.read()
    send_email(from_email, to_email, subject, body, **kwargs)

def send_public_ip():
    email_address = 'wdawn730@gmail.com'
    fname = '/tmp/public_ip'
    subject = 'Public IP Update'
    password = 'Annie20b@nana'

    if (os.path.exists(fname)):
        send_email_from_file(email_address, email_address, subject, fname,
            password=password)
    else:
        send_email(email_address, email_address, subject, 'FAILURE',
            password=passwrod)

if (__name__ == '__main__'):
    send_public_ip()
