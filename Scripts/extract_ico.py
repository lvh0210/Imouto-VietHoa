import pefile, struct, io, sys
from PIL import Image
sys.stdout.reconfigure(encoding='utf-8')

exe_path = r'D:\GameCrack\妹と過ごす1ヵ月間_Re(viethoa)\妹と過ごす1ヵ月間_Re.exe'
pe = pefile.PE(exe_path)

# Find RT_GROUP_ICON and RT_ICON
group_entries = []
for entry in pe.DIRECTORY_ENTRY_RESOURCE.entries:
    if entry.struct.Id == pefile.RESOURCE_TYPE['RT_GROUP_ICON']:
        group_entries = entry.directory.entries

# Read group icon header
grp = group_entries[0].directory.entries[0]
grp_data = pe.get_data(grp.data.struct.OffsetToData, grp.data.struct.Size)

idReserved, idType, idCount = struct.unpack('<HHH', grp_data[:6])
print(f"Group icon: count={idCount}")

# Build full .ico file
entries = []
images = []
offset = 6 + idCount * 16

for i in range(idCount):
    entry_data = grp_data[6 + i*14 : 6 + (i+1)*14]
    w, h, colors, res, planes, bpp, size, nId = struct.unpack('<BBBBHHIH', entry_data)
    
    # find corresponding RT_ICON with nId
    icon_data = None
    for entry in pe.DIRECTORY_ENTRY_RESOURCE.entries:
        if entry.struct.Id == pefile.RESOURCE_TYPE['RT_ICON']:
            for sub in entry.directory.entries:
                if sub.struct.Id == nId:
                    icon_data = pe.get_data(sub.directory.entries[0].data.struct.OffsetToData, size)
                    break
    
    entries.append(struct.pack('<BBBBHHII', w, h, colors, res, planes, bpp, size, offset))
    images.append(icon_data)
    offset += size

ico_bytes = struct.pack('<HHH', idReserved, idType, idCount) + b''.join(entries) + b''.join(images)

out_ico = r'C:\Users\LvH\.gemini\antigravity\brain\35a34904-5000-44fe-a7dc-588d0018da1f\scratch\game.ico'
with open(out_ico, 'wb') as f:
    f.write(ico_bytes)

print(f"Wrote {len(ico_bytes)} bytes to {out_ico}")

img = Image.open(out_ico)
print(f"Pillow opened ICO successfully! size={img.size}")
out_png = r'C:\Users\LvH\.gemini\antigravity\brain\35a34904-5000-44fe-a7dc-588d0018da1f\scratch\icon.png'
img.save(out_png, 'PNG')
print(f"Saved {out_png}")
