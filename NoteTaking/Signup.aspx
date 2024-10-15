<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="NoteTaking.Signup" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up</title>
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
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 320px;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
            font-size: 1.5rem;
        }

        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 1rem;
        }

        input[type="submit"], button {
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 1rem;
            cursor: pointer;
        }

        input[type="submit"]:hover, button:hover {
            background-color: #218838;
        }

        .message {
            margin-top: 10px;
            color: #e74c3c;
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
            <h2>Sign Up</h2>
            <asp:TextBox ID="txtUsername" runat="server" Placeholder="Username"></asp:TextBox>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Placeholder="Password"></asp:TextBox>
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" Placeholder="Confirm Password"></asp:TextBox>
            <asp:Button ID="btnSignUp" runat="server" Text="Sign Up" OnClick ="btnSignUp_Click" />
            <p>Already have an account? <a href="Login.aspx">Login here</a></p>
            <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
        </div>
    </form>
</body>
</html>