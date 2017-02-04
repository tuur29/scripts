
# This powershell script will parse your running minecraft server logs and show a notification on the windows 10 host computer
# and sends a pushbullet notification to a mobile device of your choice when a certain player isn't online
# The script also monitors a regex string so a player can create his own notification and notify the server

# Uncomment line 62 and put a picture in the working directory to add an icon to the noticiation

# Use case: I run a minecraft server for my younger brother on my desktop pc in the background.
# This script let's me monitor when someone joins or leaves the server. Additionally he is notified of others when he's offline



# CONFIG

$admin = "username"
$keywordREGEX = "\bkeyword\b"
$title = "Minecraft Server"

# https://www.pushbullet.com/my-channel
$pushbulletToken = '...'
$pushbulletChannel = '...'


# APPLICATION

# Allow only one instance

$p = Get-WmiObject Win32_Process -Filter "Name='powershell.exe' AND CommandLine LIKE '%checkMCServer.ps1%'"
if ($p.Count) {
	"Already running"
	exit
}

$adminNotOnline = 1
$notFirst = 0
$curr = 0

#functions
function sendNotification{

    if ($line -Match "\] \[Server thread") {
        $line = $line.Substring(33)
    }

    $headers = @{}
    $headers["Access-Token"] = $pushbulletToken
    $headers["Content-Type"] = "application/json"
    $param = '{"channel_tag": "'+ $pushbulletChannel +'", "type":"note", "title":"' + $title + '", "body":"' + $line + '" }'

    Invoke-WebRequest "https://api.pushbullet.com/v2/pushes" -Headers $headers -Method POST -Body $param
}

function sendLocalNotification($line) {

	if ($line -Match "\] \[Server thread") {
		$line = $line.Substring(33)
	}

	[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
	$template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText02)

	#Convert to .NET type for XML manipuration
	$toastXml = [xml] $template.GetXml()
	#$toastXml.GetElementsByTagName("image")[0].src = $PSScriptRoot+"\logo.png"
	$toastXml.GetElementsByTagName("text")[0].AppendChild($toastXml.CreateTextNode($title)) > $null
	$toastXml.GetElementsByTagName("text")[1].AppendChild($toastXml.CreateTextNode($line)) > $null

	#Convert back to WinRT type
	$xml = New-Object Windows.Data.Xml.Dom.XmlDocument
	$xml.LoadXml($toastXml.OuterXml)

	$toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
	$toast.Group = $title
	$toast.ExpirationTime = [DateTimeOffset]::Now.AddMinutes(1)

	$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Powershell")
	$notifier.Show($toast);
}


#routine

$process = 1
while ($process){

	# refresh file
	$file = Get-Content logs/latest.log
	$length = $file.Count

	if ($curr -ne $length) {

		$lines = ($file)[$curr .. $length]

		foreach ($line in $lines) {

			if ($line -Match $admin+" joined the game") {
				$adminNotOnline = 0
			} elseif ($line -Match $admin+" left the game") {
				$adminNotOnline = 1
			}

			if ($notFirst) {
				if ($line -Match " (joined|left) the game") {
					sendLocalNotification $line + "*"
					if ($adminNotOnline -And $line -NotMatch $admin){
						sendNotification $line
					}

				} elseif ($line -Match "("+$keywordREGEX+"|tick|crash|[^vil]lag)") {
					sendLocalNotification $line

				} elseif ($line -Match "n: You are not white-listed" ) {

                    $name = $line.IndexOf("name=") + 5
                    $prop = $line.IndexOf(",properties=")
                    $line = $line.Substring($name,$prop-$name)
                    $line = $line + " is not white-listed"

                    if ($adminNotOnline -And $line -NotMatch $admin) {
                        sendNotification $line
                        $line = $line + "*"
                    }
                    sendLocalNotification $line

                } elseif ( $adminNotOnline -And $line -Match "lasse" ) {
                    sendNotification $line
                    sendLocalNotification $line + "*"
                }
			}

		}

		# restart loop
		$notFirst = 1
		$curr = $length
	}

	start-sleep -seconds 5
	$process = Get-WmiObject Win32_Process -Filter "Name='java.exe' AND CommandLine LIKE '%minecraft_server%'"
}

exit
