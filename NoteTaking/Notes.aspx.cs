using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NoteTaking
{
    public partial class Notes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindNotes();
            }
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindNotes(txtSearch.Text.Trim());
        }
        protected void btnSaveNote_Click(object sender, EventArgs e)
        {
            // Validate title
            if (string.IsNullOrWhiteSpace(txtTitle.Text))
            {
                lblMessage.Text = "The title is required.";
                return;
            }
            if (txtTitle.Text.Length < 6)
            {
                lblMessage.Text = "The title must be at least 6 characters.";
                return;
            }

            int userId = GetCurrentUserId();
            string title = txtTitle.Text.Trim();
            string content = txtContent.Text.Trim();
            int noteId = 0;

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    string query;

                    if (Session["SelectedNoteId"] != null)
                    {
                        noteId = (int)Session["SelectedNoteId"];
                        query = "UPDATE Notes SET Title = @Title, Content = @Content WHERE NoteID = @NoteID";
                    }
                    else
                    {
                        query = "INSERT INTO Notes (Title, Content, CreatedBy) VALUES (@Title, @Content, @CreatedBy); SELECT SCOPE_IDENTITY();";
                    }

                    SqlCommand cmd = new SqlCommand(query, conn, transaction);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Content", content);
                    cmd.Parameters.AddWithValue("@CreatedBy", userId);

                    if (noteId > 0)
                    {
                        cmd.Parameters.AddWithValue("@NoteID", noteId);
                    }

                    if (noteId == 0)
                    {
                        noteId = Convert.ToInt32(cmd.ExecuteScalar());
                    }
                    else
                    {
                        cmd.ExecuteNonQuery();
                    }

                    // Validate collaborators
                    string[] collaborators = hfCollaborators.Value.Split(',');
                    if (collaborators.Length > 0)
                    {
                        foreach (string collaborator in collaborators)
                        {
                            if (!string.IsNullOrEmpty(collaborator))
                            {
                                // Check if the user exists
                                string checkUserQuery = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
                                SqlCommand checkUserCmd = new SqlCommand(checkUserQuery, conn, transaction);
                                checkUserCmd.Parameters.AddWithValue("@Username", collaborator.Trim());
                                int userExists = (int)checkUserCmd.ExecuteScalar();

                                if (userExists == 0)
                                {
                                    lblMessage.Text = $"Collaborator '{collaborator}' does not exist.";
                                    transaction.Rollback();  // Rollback the transaction
                                    return;
                                }

                                string collaboratorQuery = "INSERT INTO Collaborators (NoteID, UserID) SELECT @NoteID, UserID FROM Users WHERE Username = @Username";
                                SqlCommand collaboratorCmd = new SqlCommand(collaboratorQuery, conn, transaction);
                                collaboratorCmd.Parameters.AddWithValue("@NoteID", noteId);
                                collaboratorCmd.Parameters.AddWithValue("@Username", collaborator.Trim());
                                collaboratorCmd.ExecuteNonQuery();
                            }
                        }
                    }

                    transaction.Commit();

                    BindNotes();
                    Session["SelectedNoteId"] = null;

                    // Clear form
                    txtTitle.Text = "";
                    txtContent.Text = "";
                    fuFile.Attributes.Clear();
                    txtCollaboratorUsername.Text = "";
                    hfCollaborators.Value = "";

                    lblMessage.Text = "Note saved successfully.";
                    ScriptManager.RegisterStartupScript(this, GetType(), "clearForm", "clearNoteForm();", true);
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    lblMessage.Text = "Error saving note: " + ex.Message;
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Response.Redirect("~/Login.aspx");
        }

        protected void EditNote_Click(object sender, EventArgs e)
        {
            Button btn = (Button)sender;
            int selectedNoteId = Convert.ToInt32(btn.CommandArgument);
            Response.Redirect("EditNote.aspx?NoteID=" + selectedNoteId);
        }

        private int GetCurrentUserId()
        {
            string username = HttpContext.Current.User.Identity.Name;
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string query = "SELECT UserID FROM Users WHERE Username = @Username";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", username);

                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        private void BindNotes(string searchTerm = "")
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string query = @"
            SELECT Notes.NoteID, Notes.Title, Notes.Content, 
            CASE WHEN Notes.CreatedBy = @UserID THEN 1 ELSE 0 END AS IsOwner, 
            STRING_AGG(Users.Username, ', ') AS Collaborators
            FROM Notes
            LEFT JOIN Collaborators ON Notes.NoteID = Collaborators.NoteID
            LEFT JOIN Users ON Collaborators.UserID = Users.UserID
            WHERE (Notes.CreatedBy = @UserID OR Collaborators.UserID = @UserID)
            AND (@SearchTerm = '' OR Notes.Title LIKE '%' + @SearchTerm + '%')
            GROUP BY Notes.NoteID, Notes.Title, Notes.Content, Notes.CreatedBy";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", GetCurrentUserId());
                cmd.Parameters.AddWithValue("@SearchTerm", searchTerm);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptNotes.DataSource = dt;
                rptNotes.DataBind();
            }
        }
    }
}
