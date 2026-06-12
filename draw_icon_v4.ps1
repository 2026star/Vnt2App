Add-Type -AssemblyName System.Drawing
$imgPath = "assets\app_icon.png"
$img = [System.Drawing.Image]::FromFile($imgPath)
$bmp = New-Object System.Drawing.Bitmap($img)
$img.Dispose()
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(46, 213, 115))
$r = [int]($bmp.Width / 2.2)
$x = [int]($bmp.Width - $r - 10)
$y = [int]($bmp.Height - $r - 10)
$ellipseRect = New-Object System.Drawing.Rectangle($x, $y, $r, $r)
$g.FillEllipse($brush, $ellipseRect)
$g.Dispose()
$bmp.Save("assets\app_icon_connected.png", [System.Drawing.Imaging.ImageFormat]::Png)

$iconStream = New-Object System.IO.FileStream("assets\app_icon_connected.ico", [System.IO.FileMode]::Create)
$iconWriter = New-Object System.IO.BinaryWriter($iconStream)
$iconWriter.Write([int16]0)
$iconWriter.Write([int16]1)
$iconWriter.Write([int16]1)

$w = $bmp.Width
if ($w -ge 256) { $w = 0 }
$h = $bmp.Height
if ($h -ge 256) { $h = 0 }

$iconWriter.Write([byte]$w)
$iconWriter.Write([byte]$h)
$iconWriter.Write([byte]0)
$iconWriter.Write([byte]0)
$iconWriter.Write([int16]0)
$iconWriter.Write([int16]32)
$ms = New-Object System.IO.MemoryStream
$bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
$iconWriter.Write([int]$ms.Length)
$iconWriter.Write([int]22)
$iconWriter.Write($ms.ToArray())
$iconWriter.Flush()
$iconWriter.Close()
$bmp.Dispose()
