<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EditNote.aspx.cs" Inherits="NoteTaking.EditNote" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Note</title>
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
            max-width: 600px;
            margin: 0 auto; 
            background-color: var(--card-color);
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 50px;
        }

        .note-title, .note-content {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-size: 1rem;
            background-color: #f9f9f9;
        }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
        }

        .btn-save {
            background-color: var(--secondary-color);
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn-save:hover {
            background-color: #27ae60;
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

        .note-content {
            resize: none;
        }
        .btn-back {
            background-color: var(--primary-color);
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 20px;
        }

        .btn-back:hover {
            background-color: #2980b9;
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
    </style>

    <script type="text/javascript">
        function addCollaborator() {
            var collaboratorInput = document.getElementById('<%= txtCollaboratorUsername.ClientID %>');
            var collaboratorList = document.getElementById('collaboratorList');
            var collaboratorName = collaboratorInput.value.trim();

            if (collaboratorName) {
                var li = document.createElement('li');
                li.innerHTML = collaboratorName + ' <button type="button" onclick="removeCollaborator(this)">Remove</button>';
                collaboratorList.appendChild(li);
                collaboratorInput.value = '';
            }
        }

        function removeCollaborator(button) {
            button.parentElement.remove();
        }

        function getCollaborators() {
            var collaboratorList = document.getElementById('collaboratorList');
            var collaborators = [];
            for (var i = 0; i < collaboratorList.children.length; i++) {
                collaborators.push(collaboratorList.children[i].textContent.split(' ')[0]);
            }
            document.getElementById('<%= hfCollaborators.ClientID %>').value = collaborators.join(',');
        }

        function loadCollaborators(existingCollaborators) {
            var collaboratorList = document.getElementById('collaboratorList');
            existingCollaborators.forEach(function (collaborator) {
                var li = document.createElement('li');
                li.innerHTML = collaborator + ' <button type="button" onclick="removeCollaborator(this)">Remove</button>';
                collaboratorList.appendChild(li);
            });
        }

        document.addEventListener('DOMContentLoaded', function () {
            var collaborators = <%= hfCollaborators.Value != "" ? $"'{hfCollaborators.Value}'.split(',')" : "[]" %>;
            loadCollaborators(collaborators);
        });

        function confirmDelete() {
            return confirm('Are you sure you want to delete this note?');
        }

        function removeFile(fileId, noteId) {
            if (confirm('Are you sure you want to delete this file?')) {
                window.location.href = 'EditNote.aspx?NoteID=' + noteId + '&DeleteFileID=' + fileId;
            }
        }
        function updateFileName() {
            var input = document.getElementById('fuFile');
            var fileName = input.value.split('\\').pop();
            document.getElementById('fileName').textContent = fileName || 'No file chosen';
        }
    </script>
</head>
<body>
    <h1>Edit Note</h1>
    <form id="form1" runat="server">
        <div class="container">
            <asp:TextBox ID="txtTitle" runat="server" CssClass="note-title" Placeholder="Title"></asp:TextBox>
            <asp:TextBox ID="txtContent" runat="server" TextMode="MultiLine" CssClass="note-content" Rows="5" Placeholder="Start typing your note..."></asp:TextBox>

            <div class="file-list">
                <h3>Attached Files</h3>
                <ul id="fileList" class="file-list">
                    <% foreach (var file in AttachedFiles) { %>
                        <li>
                            <a href='<%= ResolveUrl("~/Uploads/" + file.FileName) %>'><%= file.FileName %></a>
                           <button type="button" onclick="removeFile('<%= file.FileID %>', '<%= Request.QueryString["NoteID"] %>')" style="background-color: #ff4d4d; color: white; border: none; padding: 10px 20px; border-radius: 5px; font-size: 14px; cursor: pointer;">
                              Remove
                           </button>

                        </li>
                    <% } %>
                </ul>
            </div>

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
                <asp:Button ID="btnSaveNote" runat="server" Text="Save Changes" OnClick="btnSaveNote_Click" OnClientClick="getCollaborators()" CssClass="btn-save" />
                <asp:Button ID="btnDeleteNote" runat="server" Text="Delete Note" CssClass="btn-save" OnClick="btnDeleteNote_Click" OnClientClick="return confirmDelete();" />
            </div>
            <div>
                <asp:Button ID="btnBackHome" runat="server" Text="Back to Home" PostBackUrl="~/Notes.aspx" CssClass="btn-back" />
            </div>
        </div>
    </form>
</body>
</html>