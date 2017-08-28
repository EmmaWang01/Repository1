using System.Drawing;
using System.Windows.Forms;

namespace LoanCenter
{
    public partial class UserControl1 : UserControl
    {
        string msg = "";

        public UserControl1()
        {
            InitializeComponent();
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            e.Graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            e.Graphics.TextRenderingHint = System.Drawing.Text.TextRenderingHint.ClearTypeGridFit;
            using (Pen pen = new Pen(Color.CornflowerBlue, 8.0f))
            {
                RectangleF r = this.ClientRectangle;
                //e.Graphics.DrawEllipse(pen, r);
                StringFormat sf = new StringFormat();
                sf.Alignment = StringAlignment.Center;
                sf.LineAlignment = StringAlignment.Center;
                sf.Trimming = StringTrimming.EllipsisCharacter;
                e.Graphics.DrawString(msg, new Font("Tahoma", 24), Brushes.CornflowerBlue, r, sf);
            }
            base.OnPaint(e);
        }
    }
}
