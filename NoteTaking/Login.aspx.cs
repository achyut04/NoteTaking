using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NoteTaking
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (IsPostBack)
            {
                string username = txtUsername.Text;
                string password = txtPassword.Text;

                if (ValidateUser(username, password))
                {
                    FormsAuthentication.SetAuthCookie(username, false);

                    string returnUrl = Request.QueryString["ReturnUrl"];
                    if (!String.IsNullOrEmpty(returnUrl))
                    {
                        Response.Redirect(returnUrl);
                    }
                    else
                    {
                        Response.Redirect("~/Home.aspx");
                    }
                }
                else
                {
                    lblError.Text = "Invalid username or password.";
                }
            }
        }
        private bool ValidateUser(string username, string password)
        {
            return (username == "admin" && password == "password");
        }

        protected void txtPassword_TextChanged(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string password = txtPassword.Text;

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string query = "SELECT UserID, PasswordHash FROM Users WHERE Username = @Username";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Username", username);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string storedHash = reader["PasswordHash"].ToString();
                    if (BCrypt.Net.BCrypt.Verify(password, storedHash))
                    {
                        FormsAuthentication.SetAuthCookie(username, true);
                        Response.Redirect("Notes.aspx");
                    }
                    else
                    {
                        lblError.Text = "Invalid username or password.";
                    }
                }
                else
                {
                    lblError.Text = "Invalid username or password.";
                }
            }
        }
    }
}