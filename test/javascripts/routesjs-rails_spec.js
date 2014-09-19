describe("Routes", function() {
  beforeEach(function() {
    Routes.setBaseUrl("//example.com/");
  });

  describe("simple path and url generation", function() {
    beforeEach(function() {
      Routes.initRoutes({
        "oauthToken": "/oauth/token",
        "adminRoot": "/admin"
      });
    });

    it("makes a path function for each route", function() {
      expect(Routes.oauthTokenPath()).toBe("/oauth/token");
      expect(Routes.adminRootPath()).toBe("/admin");
    });

    it("makes a url function for each route", function() {
      expect(Routes.oauthTokenUrl()).toBe("//example.com/oauth/token");
      expect(Routes.adminRootUrl()).toBe("//example.com/admin");
    });
  });

  describe("token replacement with object", function() {
    beforeEach(function() {
      Routes.initRoutes({
        "user": "/users/:id",
        "userRoles": "/users/:id/roles",
        "userRole": "/users/:id/roles/:role_id"
      });
    });

    it("replaces tokens with values from object", function() {
      user = {
        id: 1,
        role_id: 2
      };

      expect(Routes.userPath(user)).toBe("/users/1");
      expect(Routes.userRolesPath(user)).toBe("/users/1/roles");
      expect(Routes.userRoleUrl(user)).toBe("//example.com/users/1/roles/2");
    });
  });

  describe("token replacement with arguments", function() {
    beforeEach(function() {
      Routes.initRoutes({
        "root": "/",
        "user": "/users/:id",
        "userRole": "/users/:id/roles/:role_id"
      });
    });

    it("replaces tokens with ordered arguments", function() {
      expect(Routes.userPath(1)).toBe("/users/1");
      expect(Routes.userRoleUrl(1, "admin")).toBe("//example.com/users/1/roles/admin");
    });

    it("ignores extra arguments", function() {
      expect(Routes.userPath(1, "this", 2, "be", "ignored")).toBe("/users/1");
    });

    it("returns the unmodified route when no tokens are found", function() {
      expect(Routes.rootPath(1, 2)).toBe("/");
    });
  });
});
