zpackage com.management.auction.security;

import com.management.auction.services.admin.AdminLoginService;
import com.management.auction.services.user.UserLoginService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.web.authentication.preauth.AbstractPreAuthenticatedProcessingFilter;
public class PreFilter extends AbstractPreAuthenticatedProcessingFilter {
    public PreFilter(AdminLoginService admin, UserLoginService user){
        Manager manager=new Manager(admin,user);
        super.setAuthenticationManager(manager);
    }
    @Override
    protected Object getPreAuthenticatedPrincipal(HttpServletRequest request) {
        return request.getHeader("tk");
    }

    @Override
    protected Object getPreAuthenticatedCredentials(HttpServletRequest request) {
        return null;
    }
}
