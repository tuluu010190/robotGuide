#!/usr/bin/env python
# -*- coding: utf-8 -*-

import hmac
import hashlib
import base64
import binascii
import urllib
import datetime
import md5
import random

def random_6_digits():
    return ''.join([str(random.randint(0,9)) for i in range(6)])

def get_type(val):
    return type(val)

def do_format_string(string, *args):
    x = string % (args)
    return x

def convert_to_unicode(val):
    if val is None:
        return val
    return val.decode('utf-8')

def convert_to_float(val):
    try:
        return float(val)
    except TypeError:
        return None
    
def convert_to_int(val):
    try:
        return int(val)
    except TypeError:
        return None

def list_to_string(separator=",", quote='"' , *vals):
    s = ""
    for val in vals:
        if quote is not None:
            s += quote + val + quote + separator
        else:
            s += val + separator
        
    return s[0:(len(s) - len(separator))]
        
    
def string_start_with(text, startwith):
    return text.startswith(startwith)

def encode_barcode(barcode):
    return barcode.replace("|","%7C").replace(" ","+")

def get_barcode_part_by_index(barcode, idx):
    parts = barcode.split(" ")
    if idx==0:
        return parts[0][1:]
    else:
        return parts[idx]

def get_var_type(var):
    return type(var)

def extract_value_from_strings(text, keyword):
    lines = text.split("\n")
    for line in lines:
        idx = line.find(keyword)
        if idx >= 0:
            return line[idx + len(keyword):].strip()

def encode_base64_SHA256(secret, message):
    secretBytes = bytes(secret).encode('utf-8')    
    messageBytes = bytes(message).encode('utf-8')
    signature = base64.b64encode(hmac.new(secretBytes, messageBytes, digestmod=hashlib.sha256).digest())
    return signature

def encode_hex_SHA256(secret, message):
    secretBytes = bytes(secret).encode('utf-8')    
    messageBytes = bytes(message).encode('utf-8')
    cipher =  hmac.new(secretBytes, messageBytes, digestmod=hashlib.sha256).digest()
    signature = binascii.hexlify(cipher)
    return signature

def encode_hmac_SHA1(secret, message):
    from hashlib import sha1
    import hmac
    cipher = hmac.new(str(secret), str(message), sha1).digest()
    signature = binascii.hexlify(cipher)
    return signature

def encode_MD5(message):
    m = md5.new()
    message = message.encode('utf-8')
    m.update(message)
    cipher = m.hexdigest()
    return cipher

def encode_url_base64(message):
    return urllib.quote_plus(base64.b64encode(message))

def get_text_between(text, left, right):
    if text is None:
        return ""
    idx = text.find(left)
    if idx < 0:
        return ""
    idx2 = text.find(right, idx + len(left))
    if idx2 < 0:
        return ""
    return text[idx + len(left) : idx2]

def encode_url_pmgw(secret):
       
    secretBytes = secret.encode('utf-8')    
    message = urllib.quote_plus(secretBytes,'=&')

    return message

def date_format (year,month,day,timeformat):
    timee = datetime.date(int(year),int(month),int(day))
    return timee.strftime(timeformat)
	
def float_to_comma(number):
    return format(number, ',.2f');
	
def covert_telno_to_format(telno):
    t = telno[:3];
    e = telno[3:6];
    l = telno[6:10];
    tel = '{0}-{1}-{2}'.format(t,e,l);
    return tel;



#print encode_MD5("a8ab9a46795f773703666bcf872bc8f2KIOSK400400010002ECASH201547062414413511000")

#print encode_hmac_SHA1("tutukaKey","Load000166811234567100002223022015032717114248582520150327T17:11:42")
#print encode_hmac_SHA1("tutukaKey","Load000166811234567100002223022015032717124868242320150327T17:12:48")
#print encode_hmac_SHA1("1111","2222")
#print encode_hmac_SHA1("tutukaKey","44444444444")

#print get_text_between("rint encode_hex_SHA256(\"xxxxx\",กหดหก \"yyyyy\")", "\"xxxx", "yyyyy")
#print encode_hex_SHA256("xxxxx", "yyyyy")
#97f50eed1079c9460f2bb9ddf7dc2e4258471f301ad2c1f14ad50144c4de4303
#4b56336bf91efea64e60a90cec42d6a0844e5de5ea0661d872d929a1bbaba25d
# encode_secret_key("12345", "message")
