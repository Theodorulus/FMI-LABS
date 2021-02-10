using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(FriendRequest.Startup))]
namespace FriendRequest
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
