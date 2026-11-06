$files = Get-ChildItem "D:\VibeCode\Game_VietHoa\Imouto_Mobile_Project\ExportedProject\Assets\Shader\*Error*.shader"
foreach ($f in $files) {
    $raw = [System.IO.File]::ReadAllText($f.FullName, [System.Text.Encoding]::UTF8)
    $raw = $raw.Replace("return float4(1.0, 1.0, 1.0, 1.0);", "return float4(1.0, 0.0, 1.0, 1.0);")
    [System.IO.File]::WriteAllText($f.FullName, $raw, [System.Text.Encoding]::UTF8)
    Write-Host "Updated Error Shader:" $f.Name
}
