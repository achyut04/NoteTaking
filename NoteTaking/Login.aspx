<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="NoteTaking.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }

        .container {
            background-color: white;
            padding: 40px 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 360px;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
            font-size: 1.8rem;
            color: #333;
        }

        label {
            display: block;
            text-align: left;
            font-weight: 500;
            margin-bottom: 8px;
            color: #333;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
            color: #333;
            background-color: #f9f9f9;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus, input[type="password"]:focus {
            border-color: #007BFF;
            outline: none;
        }

        input[type="submit"], button {
            width: 100%;
            padding: 12px;
            background-color: #007BFF;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="submit"]:hover, button:hover {
            background-color: #0056b3;
        }

        .message {
            margin-top: 10px;
            color: #e74c3c;
            font-size: 0.9rem;
        }

        p {
            margin-top: 15px;
            font-size: 0.9rem;
            color: #555;
        }

        a {
            color: #007BFF;
            text-decoration: none;
            font-weight: 500;
        }

        a:hover {
            text-decoration: underline;
        }

        @media (max-width: 400px) {
            .container {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Login</h2>
            <label for="txtUsername">Username</label>
            <asp:TextBox ID="txtUsername" runat="server" Placeholder="Enter your username"></asp:TextBox>
            
            <label for="txtPassword">Password</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Enter your password"></asp:TextBox>
            
            <asp:Button ID="btnLogin" runat="server" Text="Login" Height="40px" OnClick="btnLogin_Click" />
            
            <p>Don't have an account? <a href="Signup.aspx">Sign up here</a></p>
            
            <asp:Label ID="lblError" runat="server" CssClass="message"></asp:Label>
        </div>
    </form>
</body>
</html>
