import zipfile, io, os, sys, struct, hashlib, base64, datetime
from PIL import Image
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.serialization import pkcs7
from cryptography import x509
from cryptography.x509.oid import NameOID

sys.stdout.reconfigure(encoding='utf-8')

base_apk = r"D:\Downloads\Winlator_11.2.apk"
game_zip = r"D:\Downloads\妹と過ごす1ヵ月間_Re(viethoa).zip"
script_dir = os.path.dirname(os.path.abspath(__file__))
repo_dir = os.path.dirname(script_dir)
icon_path = os.path.join(repo_dir, "Data", "icon.png")
output_apk = r"D:\Downloads\Imouto_Re_VietHoa.apk"

print(f"Loading icon from {icon_path}...")
base_icon = Image.open(icon_path).convert('RGBA')

# Pre-generate resized icons
icon_cache = {}
for size in [48, 72, 96, 144, 192, 256]:
    img = base_icon.resize((size, size), Image.Resampling.LANCZOS)
    buf = io.BytesIO()
    img.save(buf, format='PNG')
    icon_cache[size] = buf.getvalue()

def get_best_icon(filename):
    if 'xxxhdpi' in filename: size = 192
    elif 'xxhdpi' in filename: size = 144
    elif 'xhdpi' in filename: size = 96
    elif 'hdpi' in filename: size = 72
    elif 'mdpi' in filename: size = 48
    else: size = 96
    return icon_cache.get(size, icon_cache[96])

print(f"Reading base APK from {base_apk}...")
with zipfile.ZipFile(base_apk, 'r') as src_zip:
    apk_files = {}
    for item in src_zip.infolist():
        if item.filename.startswith('META-INF/') and (item.filename.endswith('.SF') or item.filename.endswith('.RSA') or item.filename.endswith('.MF')):
            continue # strip old signatures
        data = src_zip.read(item.filename)
        
        # Replace launcher icons
        if 'ic_launcher' in item.filename and item.filename.endswith('.png'):
            data = get_best_icon(item.filename)
            print(f"Replaced icon: {item.filename}")
        
        # In-place replace 'Winlator' with 'ImoutoRe' in resources.arsc
        if item.filename == 'resources.arsc':
            # String #5548 is 'Winlator' (8 bytes), replace with 'ImoutoRe' (8 bytes)
            old_str = b'\x08\x08Winlator\x00'
            new_str = b'\x08\x08ImoutoRe\x00'
            if old_str in data:
                data = data.replace(old_str, new_str, 1)
                print("Replaced app name string in resources.arsc with 'ImoutoRe'!")
        
        apk_files[item.filename] = data

# Add game payload to assets/game.zip
print(f"Reading game payload from {game_zip}...")
with open(game_zip, 'rb') as gf:
    game_bytes = gf.read()

apk_files['assets/game.zip'] = game_bytes
print(f"Added assets/game.zip ({len(game_bytes)} bytes) to APK payload!")

# Sign APK with v1 signature (JAR signing)
print("Generating RSA key and self-signed X.509 certificate for APK signing...")
key = rsa.generate_private_key(public_exponent=65537, key_size=2048)
subject = issuer = x509.Name([
    x509.NameAttribute(NameOID.COMMON_NAME, "妹と過ごす1ヵ月間_Re"),
    x509.NameAttribute(NameOID.ORGANIZATION_NAME, "VietHoa"),
])
cert = (
    x509.CertificateBuilder()
    .subject_name(subject)
    .issuer_name(issuer)
    .public_key(key.public_key())
    .serial_number(x509.random_serial_number())
    .not_valid_before(datetime.datetime.now(datetime.timezone.utc) - datetime.timedelta(days=1))
    .not_valid_after(datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(days=7300))
    .sign(key, hashes.SHA256())
)

# Write unsigned APK
unsigned_apk = output_apk + ".unsigned"
print(f"Writing base APK to {unsigned_apk}...")
with zipfile.ZipFile(unsigned_apk, 'w', compression=zipfile.ZIP_DEFLATED) as out_zip:
    for filename, data in apk_files.items():
        out_zip.writestr(filename, data)

# Sign with APK Signature Scheme v2 & v3 using sign_apk
print("Signing APK with APK Signature Schemes v2 & v3...")
from sign_apk import signer, keys
km = keys.KeyMaterial(private_key=key, certificate=cert)
signer.sign_apk(unsigned_apk, output_apk, key_material=km, v2=True, v3=True)

if os.path.exists(unsigned_apk):
    os.remove(unsigned_apk)

out_size = os.path.getsize(output_apk)
print(f"SUCCESS! Created signed standalone APK (v2+v3): {output_apk}")
print(f"Final APK size: {out_size / (1024*1024):.2f} MB")
