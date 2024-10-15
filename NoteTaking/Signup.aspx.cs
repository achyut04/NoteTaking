using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace NoteTaking
{
    public partial class Signup : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (password != confirmPassword)
            {
                lblMessage.Text = "Passwords do not match!";
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["NoteTakingCS"].ConnectionString))
            {
                string checkUserQuery = "SELECT COUNT(*) FROM Users WHERE Username = @Username";
                SqlCommand checkCmd = new SqlCommand(checkUserQuery, conn);
                checkCmd.Parameters.AddWithValue("@Username", username);

                conn.Open();
                int userExists = (int)checkCmd.ExecuteScalar();

                if (userExists > 0)
                {
                    lblMessage.Text = "Username already exists!";
                    return;
                }

                string hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);

                string insertUserQuery = "INSERT INTO Users (Username, PasswordHash) VALUES (@Username, @PasswordHash)";
                SqlCommand insertCmd = new SqlCommand(insertUserQuery, conn);
                insertCmd.Parameters.AddWithValue("@Username", username);
                insertCmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);

                insertCmd.ExecuteNonQuery();

                lblMessage.Text = "Registration successful! You can now log in.";
                Response.Redirect("Login.aspx");
            }
        }
    }
}