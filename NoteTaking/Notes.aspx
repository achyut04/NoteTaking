<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Notes.aspx.cs" Inherits="NoteTaking.Notes" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <title>My Notes</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        :root {
            --primary-color: #3498db;
            --secondary-color: #2ecc71;
            --background-color: #f5f7fa;
            --text-color: #34495e;
            --card-color: #ffffff;
        }

        body {
            background-color: var(--background-color);
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            color: var(--text-color);
        }

        h1 {
            color: var(--primary-color);
            text-align: center;
            margin-top: 40px;
            font-size: 2.5rem;
            font-weight: 300;
            letter-spacing: 2px;
        }

        .container {
            width: 100%;
            max-width: 1200px;
            padding: 0 20px;
            box-sizing: border-box;
            margin: 0 auto;
        }

        .add-note-box {
            background-color: var(--card-color);
            border-radius: 8px;
            padding: 15px 20px;
            width: 100%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin: 30px auto;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
        }

        .add-note-box:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .add-note-box input {
            border: none;
            padding: 10px;
            width: 100%;
            font-size: 1.1rem;
            color: var(--text-color);
            background-color: transparent;
            outline: none;
            cursor: pointer;
        }

        .note-form {
            display: none;
            background-color: var(--card-color);
            border-radius: 8px;
            padding: 25px;
            width: 100%;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin: 0 auto 30px;
            position: relative;
            z-index: 10;
        }

        .note-form input[type="text"], 
        .note-form textarea {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-size: 1rem;
            background-color: #f9f9f9;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .note-form input[type="text"]:focus, 
        .note-form textarea:focus {
            border-color: var(--primary-color);
            outline: none;
        }

        .note-form textarea {
            resize: none;
            height: 150px;
        }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }

        .note-form .btn-save {
            background-color: var(--secondary-color);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .note-form .btn-save:hover {
            background-color: #27ae60;
        }

        .file-upload {
            display: flex;
            align-items: center;
        }

        .file-upload input[type="file"] {
            display: none;
        }

        .file-upload label {
            background-color: #f1f1f1;
            color: var(--text-color);
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .file-upload label:hover {
            background-color: #e0e0e0;
        }

        .file-name {
            margin-left: 10px;
            font-size: 0.9rem;
            color: #777;
        }

        .note-container {
            display: grid;
            grid-template-columns: repeat(4, 1fr); 
            gap: 30px; 
            width: 100%;
            padding: 20px; 
            box-sizing: border-box;
        }

        .note-card {
            background-color: var(--card-color);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.3s ease;
            width: 100%;
            box-sizing: border-box;
        }

        .note-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background-color: var(--primary-color);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.3s ease;
        }

        .note-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }

        .note-card:hover::before {
            transform: scaleX(1);
        }

        .note-title {
            font-size: 1.2rem;
            color: var(--primary-color);
            font-weight: 500;
            text-align: center; 
        }

        .message {
            color: #e74c3c;
            text-align: center;
            margin-top: 10px;
            font-weight: 500;
        }

        .collaborators {
            margin-top: 20px;
        }

        .collaborator-input {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        .collaborator-input input[type="text"] {
            flex-grow: 1;
        }

        .collaborator-input button {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .collaborator-input button:hover {
            background-color: #2980b9;
        }

        .collaborator-list {
            list-style-type: none;
            padding: 0;
        }

        .collaborator-list li {
            background-color: #f1f1f1;
            padding: 8px 12px;
            border-radius: 4px;
            margin-bottom: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .collaborator-list li button {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 4px 8px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .collaborator-list li button:hover {
            background-color: #c0392b;
        }
        .search-bar {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }

        .search-input {
            padding: 10px;
            font-size: 1rem;
            width: 300px;
            border: 1px solid #ccc;
            border-radius: 6px;
            margin-right: 10px;
        }

        .btn-search {
            background-color: var(--primary-color);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-search:hover {
            background-color: #2980b9;
        }
        .logout-container {
            position: absolute;
            top: 20px;
            right: 20px;
        }

        .btn-logout {
            background-color: #e74c3c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-logout:hover {
            background-color: #c0392b;
        }

        @media (max-width: 600px) {
            .form-footer {
                flex-direction: column;
                align-items: flex-start;
            }

            .note-form .btn-save {
                margin-top: 15px;
                width: 100%;
            }
        }

        @media (max-width: 1024px) {
            .note-container {
                grid-template-columns: repeat(2, 1fr); 
            }
        }

        @media (max-width: 600px) {
            .note-container {
                grid-template-columns: 1fr; 
            }
        }
    </style>

    <script type="text/javascript">
        function showNoteForm() {
            document.querySelector('.note-form').style.display = 'block';
            document.querySelector('.add-note-box').style.display = 'none';
        }

        function hideNoteForm() {
            document.querySelector('.note-form').style.display = 'none';
            document.querySelector('.add-note-box').style.display = 'flex';
        }

        function updateFileName() {
            var input = document.getElementById('fuFile');
            var fileName = input.value.split('\\').pop();
            document.getElementById('fileName').textContent = fileName || 'No file chosen';
        }

        function clearNoteForm() {
            document.getElementById('<%= txtTitle.ClientID %>').value = '';
            document.getElementById('<%= txtContent.ClientID %>').value = '';
            document.getElementById('<%= fuFile.ClientID %>').value = '';
            document.getElementById('fileName').textContent = 'No file chosen';
            document.getElementById('<%= txtCollaboratorUsername.ClientID %>').value = '';
            document.getElementById('collaboratorList').innerHTML = '';
            hideNoteForm();
        }

        function addCollaborator() {
            var collaboratorInput = document.getElementById('<%= txtCollaboratorUsername.ClientID %>');
            var collaboratorList = document.getElementById('collaboratorList');
            var collaboratorName = collaboratorInput.value.trim();

            if (collaboratorName) {
                var li = document.createElement('li');
                li.innerHTML = collaboratorName + ' <button onclick="removeCollaborator(this)">Remove</button>';
                collaboratorList.appendChild(li);
                collaboratorInput.value = '';
            }
        }

        function removeCollaborator(button) {
            button.parentElement.remove();
        }
        function validateNoteForm() {
            var title = document.getElementById('<%= txtTitle.ClientID %>').value.trim();

            if (!title) {
                alert("The title is required.");
                return false;
            }
            if (title.length < 6) {
                alert("The title must be at least 6 characters long.");
                return false;
            }

            // You can also add additional validation if needed
            return true;
        }

        function getCollaborators() {
            var collaboratorList = document.getElementById('collaboratorList');
            var collaborators = [];
            for (var i = 0; i < collaboratorList.children.length; i++) {
                collaborators.push(collaboratorList.children[i].textContent.split(' ')[0]);
            }
            document.getElementById('<%= hfCollaborators.ClientID %>').value = collaborators.join(',');
        }

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelector('.add-note-box').addEventListener('click', showNoteForm);

            document.addEventListener('click', function (event) {
                var noteForm = document.querySelector('.note-form');
                var addNoteBox = document.querySelector('.add-note-box');
                if (!noteForm.contains(event.target) && !addNoteBox.contains(event.target)) {
                    hideNoteForm();
                }
            });

            window.clearNoteForm = clearNoteForm;
        });
    </script>
</head>
<body>
    <h1>My Notes</h1>

    <form id="form1" runat="server">
        <div class="search-bar">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-input" Placeholder="Search notes by title..."></asp:TextBox>
            <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn-search" OnClick="btnSearch_Click" />
        </div>
        <div class="logout-container">
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
        </div>

        <div class="container">
            <div class="add-note-box" onclick="showNoteForm()">
                <input type="text" placeholder="Add a new note..." readonly />
            </div>

            <div class="note-form">
                <asp:TextBox ID="txtTitle" runat="server" CssClass="note-title" Placeholder="Title" EnableViewState="false"></asp:TextBox>
                <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" CssClass="note-content" Rows="5" Placeholder="Start typing your note..." EnableViewState="false"></asp:TextBox>
                
                <div class="collaborators">
                    <h3>Collaborators</h3>
                    <div class="collaborator-input">
                        <asp:TextBox ID="txtCollaboratorUsername" runat="server" Placeholder="Enter username"></asp:TextBox>
                        <button type="button" onclick="addCollaborator()">Add</button>
                    </div>
                    <ul id="collaboratorList" class="collaborator-list"></ul>
                    <asp:HiddenField ID="hfCollaborators" runat="server" />
                </div>

                <div class="form-footer">
                    <div class="file-upload">
                        <label for="fuFile">Choose File</label>
                        <asp:FileUpload ID="fuFile" runat="server" onchange="updateFileName()" />
                        <span id="fileName" class="file-name">No file chosen</span>
                    </div>
                   <asp:Button ID="btnSaveNote" runat="server" Text="Save Note" OnClick="btnSaveNote_Click" 
                        OnClientClick="getCollaborators(); return validateNoteForm();" CssClass="btn-save" />

                </div>
            </div>

            <div class="note-container">
                <asp:Repeater ID="rptNotes" runat="server">
                    <ItemTemplate>
                        <div class="note-card" onclick="location.href='EditNote.aspx?NoteID=<%# Eval("NoteID") %>';">
                            <div class="note-title">
                                <%# Eval("Title") %>
                            </div>  
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message" Text=""></asp:Label>
        </div>
    </form>
</body>
</html>
