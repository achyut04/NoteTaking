using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Web.Security;

namespace NoteTaking
{
    public partial class EditNote : System.Web.UI.Page
    {
        public List<FileAttachment> AttachedFiles { get; set; } = new List<FileAttachment>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["NoteID"] != null)
                {
                    int noteId = Convert.ToInt32(Request.QueryString["NoteID"]);
                    LoadNoteDetails(noteId);
                    LoadCollaborators(noteId);
                    LoadAttachedFiles(noteId);

                    if (Request.QueryString["DeleteFileID"] != null)
                    {
                        int fileId = Convert.ToInt32(Request.QueryString["DeleteFileID"]);
                        DeleteFile(fileId, noteId);
                    }
                }
            }
        }

        protected void LoadAttachedFiles(int noteId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string query = "SELECT FileID, FileName FROM Files WHERE NoteID = @NoteID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@NoteID", noteId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    AttachedFiles.Add(new FileAttachment
                    {
                        FileID = Convert.ToInt32(reader["FileID"]),
                        FileName = reader["FileName"].ToString()
                    });
                }
            }
        }

        protected void DeleteNoteAndFiles(int noteId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string deleteFilesQuery = "DELETE FROM Files WHERE NoteID = @NoteID";
                string deleteCollaboratorsQuery = "DELETE FROM Collaborators WHERE NoteID = @NoteID";
                string deleteNoteQuery = "DELETE FROM Notes WHERE NoteID = @NoteID";

                SqlCommand deleteFilesCmd = new SqlCommand(deleteFilesQuery, conn);
                deleteFilesCmd.Parameters.AddWithValue("@NoteID", noteId);

                SqlCommand deleteCollaboratorsCmd = new SqlCommand(deleteCollaboratorsQuery, conn);
                deleteCollaboratorsCmd.Parameters.AddWithValue("@NoteID", noteId);

                SqlCommand deleteNoteCmd = new SqlCommand(deleteNoteQuery, conn);
                deleteNoteCmd.Parameters.AddWithValue("@NoteID", noteId);

                conn.Open();
                deleteFilesCmd.ExecuteNonQuery();
                deleteCollaboratorsCmd.ExecuteNonQuery();
                deleteNoteCmd.ExecuteNonQuery();
            }
        }

        protected void btnDeleteNote_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["NoteID"] != null)
            {
                int noteId = Convert.ToInt32(Request.QueryString["NoteID"]);
                DeleteNoteAndFiles(noteId);
                Response.Redirect("Notes.aspx");
            }
        }

        protected void DeleteFile(int fileId, int noteId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string query = "DELETE FROM Files WHERE FileID = @FileID AND NoteID = @NoteID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@FileID", fileId);
                cmd.Parameters.AddWithValue("@NoteID", noteId);

                conn.Open();
                cmd.ExecuteNonQuery();
                Response.Redirect("EditNote.aspx?NoteID=" + noteId);
            }
        }

        protected void LoadNoteDetails(int noteId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string query = "SELECT Title, Content FROM Notes WHERE NoteID = @NoteID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@NoteID", noteId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtTitle.Text = reader["Title"].ToString();
                    txtContent.Text = reader["Content"].ToString();
                }
            }
        }

        protected void LoadCollaborators(int noteId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string query = @"
                    SELECT Users.Username
                    FROM Collaborators
                    JOIN Users ON Collaborators.UserID = Users.UserID
                    WHERE Collaborators.NoteID = @NoteID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@NoteID", noteId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                string collaborators = "";
                while (reader.Read())
                {
                    collaborators += reader["Username"].ToString() + ",";
                }

                if (collaborators.Length > 0)
                {
                    hfCollaborators.Value = collaborators.TrimEnd(',');
                }
            }
        }

        protected void btnSaveNote_Click(object sender, EventArgs e)
        {
            if (Request.QueryString["NoteID"] != null)
            {
                int noteId = Convert.ToInt32(Request.QueryString["NoteID"]);
                SaveNoteChanges(noteId);
            }
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Response.Redirect("Login.aspx");
        }
        protected void SaveNoteChanges(int noteId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string query = "UPDATE Notes SET Title = @Title, Content = @Content WHERE NoteID = @NoteID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                cmd.Parameters.AddWithValue("@Content", txtContent.Text);
                cmd.Parameters.AddWithValue("@NoteID", noteId);

                conn.Open();
                cmd.ExecuteNonQuery();

                string[] collaborators = hfCollaborators.Value.Split(',');
                string deleteCollaboratorsQuery = "DELETE FROM Collaborators WHERE NoteID = @NoteID";
                SqlCommand deleteCmd = new SqlCommand(deleteCollaboratorsQuery, conn);
                deleteCmd.Parameters.AddWithValue("@NoteID", noteId);
                deleteCmd.ExecuteNonQuery();

                foreach (string collaborator in collaborators)
                {
                    if (!string.IsNullOrEmpty(collaborator))
                    {
                        string insertCollaboratorsQuery = "INSERT INTO Collaborators (NoteID, UserID) SELECT @NoteID, UserID FROM Users WHERE Username = @Username";
                        SqlCommand insertCmd = new SqlCommand(insertCollaboratorsQuery, conn);
                        insertCmd.Parameters.AddWithValue("@NoteID", noteId);
                        insertCmd.Parameters.AddWithValue("@Username", collaborator.Trim());
                        insertCmd.ExecuteNonQuery();
                    }
                }

                if (fuFile.HasFile)
                {
                    string fileName = System.IO.Path.GetFileName(fuFile.PostedFile.FileName);
                    string filePath = Server.MapPath("~/Uploads/") + fileName;
                    fuFile.SaveAs(filePath);

                    string insertFileQuery = "INSERT INTO Files (NoteID, FileName, FilePath) VALUES (@NoteID, @FileName, @FilePath)";
                    SqlCommand insertFileCmd = new SqlCommand(insertFileQuery, conn);
                    insertFileCmd.Parameters.AddWithValue("@NoteID", noteId);
                    insertFileCmd.Parameters.AddWithValue("@FileName", fileName);
                    insertFileCmd.Parameters.AddWithValue("@FilePath", filePath);
                    insertFileCmd.ExecuteNonQuery();
                }

                Response.Redirect("Notes.aspx");
            }
        }
    }

    public class FileAttachment
    {
        public int FileID { get; set; }
        public string FileName { get; set; }
    }
}
