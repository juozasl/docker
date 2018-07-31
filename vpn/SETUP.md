## Testing the VPN Connection on Windows, iOS, and macOS

Now that you have everything set up, it's time to try it out. First, you'll need to copy the root certificate you created and install it on your client device(s) that will connect to the VPN. The easiest way to do this is to log into your server and execute this command to display the contents of the certificate file:

```
$ cat ~/vpn-certs/server-root-ca.pem
```

You'll see output similar to this:

```
Output
-----BEGIN CERTIFICATE-----
MIIFQjCCAyqgAwIBAgIIFkQGvkH4ej0wDQYJKoZIhvcNAQEMBQAwPzELMAkGA1UE

. . .

EwbVLOXcNduWK2TPbk/+82GRMtjftran6hKbpKGghBVDPVFGFT6Z0OfubpkQ9RsQ
BayqOb/Q
-----END CERTIFICATE-----
```

Copy this output to your computer, including the -----BEGIN CERTIFICATE----- and -----END CERTIFICATE----- lines, and save it to a file with a recognizable name, such as vpn_root_certificate.pem. Ensure the file you create has the .pem extension.

Alternatively, use SFTP to transfer the file to your computer.

Once you have the vpn_root_certificate.pem file downloaded to your computer, you can set up the connection to the VPN.

### Connecting from Windows

First, import the root certificate by following these steps:

1. Press WINDOWS+R to bring up the Run dialog, and enter mmc.exe to launch the Windows Management Console.
1. From the File menu, navigate to Add or Remove Snap-in, select Certificates from the list of available snap-ins, and click Add.
1. We want the VPN to work with any user, so select Computer Account and click Next.
1. We're configuring things on the local computer, so select Local Computer, then click Finish.
1. Under the Console Root node, expand the Certificates (Local Computer) entry, expand Trusted Root Certification Authorities, and then select the Certificates entry.
1. From the Action menu, select All Tasks and click Import to display the Certificate 1. Import Wizard. Click Next to move past the introduction.
1. On the File to Import screen, press the Browse button and select the certificate file that you've saved. Then click Next.
1. Ensure that the Certificate Store is set to Trusted Root Certification Authorities, and click Next.
1. Click Finish to import the certificate.

Then configure the VPN with these steps:

1. Launch Control Panel, then navigate to the Network and Sharing Center.
1. Click on Set up a new connection or network, then select Connect to a workplace.
1. Select Use my Internet connection (VPN).
1. Enter the VPN server details. Enter the server's domain name or IP address in the Internet address field, then fill in Destination name with something that describes your VPN connection. Then click Done.

Your new VPN connection will be visible under the list of networks. Select the VPN and click Connect. You'll be prompted for your username and password. Type them in, click OK, and you'll be connected.

### Connecting from iOS

To configure the VPN connection on an iOS device, follow these steps:

1. Send yourself an email with the root certificate attached.
1. Open the email on your iOS device and tap on the attached certificate file, then tap Install and enter your passcode. Once it installs, tap Done.
1. Go to Settings, General, VPN and tap Add VPN Configuration. This will bring up the VPN connection configuration screen.
1. Tap on Type and select IKEv2.
1. In the Description field, enter a short name for the VPN connection. This could be anything you like.
1. In the Server and Remote ID field, enter the server's domain name or IP address. The Local ID field can be left blank.
1. Enter your username and password in the Authentication section, then tap Done.
1. Select the VPN connection that you just created, tap the switch on the top of the page, and you'll be connected.

### Connecting from macOS

Follow these steps to import the certificate:

1. Double-click the certificate file. Keychain Access will pop up with a dialog that says "Keychain Access is trying to modify the system keychain. Enter your password to allow this."
1. Enter your password, then click on Modify Keychain
1. Double-click the newly imported VPN certificate. This brings up a small properties window where you can specify the trust levels. Set IP Security (IPSec) to Always Trust and you'll be prompted for your password again. This setting saves automatically after entering the password.

Now that the certificate is important and trusted, configure the VPN connection with these steps:

1. Go to System Preferences and choose Network.
1. Click on the small "plus" button on the lower-left of the list of networks.
1. In the popup that appears, Set Interface to VPN, set the VPN Type to IKEv2, and give the connection a name.
1. In the Server and Remote ID field, enter the server's domain name or IP address. Leave the Local ID blank.
1. Click on Authentication Settings, select Username, and enter your username and password you configured for your VPN user. Then click OK.

Finally, click on Connect to connect to the VPN. You should now be connected to the VPN.


