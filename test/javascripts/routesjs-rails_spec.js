describe("Routes", function() {
  beforeEach(function() {
    Routes.setBaseUrl("//example.com/");
  });

  describe("simple path and url generation", function() {
    beforeEach(function() {
      Routes.initRoutes({
        "routes": {
          "google": "https://www.google.com/",
          "oauthToken": "/oauth/token",
          "adminRoot": "/admin"
        }
      });
    });

    it("makes a path function for each route", function() {
      expect(Routes.oauthTokenPath().toString()).toEqual("/oauth/token");
      expect(Routes.adminRootPath().toString()).toEqual("/admin");
    });

    it("makes a url function for each route", function() {
      expect(Routes.oauthTokenUrl().toString()).toEqual("//example.com/oauth/token");
      expect(Routes.adminRootUrl().toString()).toEqual("//example.com/admin");
    });

    it("returns the raw route for both path and url when absolute", function() {
      expect(Routes.googlePath().toString()).toEqual("https://www.google.com/");
      expect(Routes.googleUrl().toString()).toEqual("https://www.google.com/");
    });
  });

  describe("token replacement with object", function() {
    beforeEach(function() {
      Routes.initRoutes({
        "routes": {
          "user": "/users/:id",
          "userRoles": "/users/:id/roles",
          "userRole": "/users/:id/roles/:role_id"
        }
      });
    });

    it("replaces tokens with values from object", function() {
      user = {
        id: 1,
        role_id: 2
      };

      expect(Routes.userPath(user).toString()).toEqual("/users/1");
      expect(Routes.userRolesPath(user).toString()).toEqual("/users/1/roles");
      expect(Routes.userRoleUrl(user).toString()).toEqual("//example.com/users/1/roles/2");
    });
  });

  describe("token replacement with arguments", function() {
    beforeEach(function() {
      Routes.initRoutes({
        "routes": {
          "root": "/",
          "user": "/users/:id",
          "userRole": "/users/:id/roles/:role_id"
        }
      });
    });

    it("replaces tokens with ordered arguments", function() {
      expect(Routes.userPath(1).toString()).toEqual("/users/1");
      expect(Routes.userRoleUrl(1, "admin").toString()).toEqual("//example.com/users/1/roles/admin");
    });

    it("ignores extra arguments", function() {
      expect(Routes.userPath(1, "this", 2, "be", "ignored").toString()).toEqual("/users/1");
    });

    it("returns the unmodified route when no tokens are found", function() {
      expect(Routes.rootPath(1, 2).toString()).toEqual("/");
    });
  });

  describe("specifying formats on a route by route basis", function() {
    beforeEach(function() {
      Routes.initRoutes({
        "routes": {
          "login": "/login",
          "user": "/users/:id",
          "userRole": "/users/:id/roles/:role_id"
        }
      });
    });

    it("uses the format property when specified", function() {
      expect(Routes.loginPath({ format: "html" }).toString()).toEqual("/login.html");
      expect(Routes.userPath({ id: 1, format: "json" }).toString()).toEqual("/users/1.json");
      expect(Routes.userRolePath({ id: 1, role_id: 2, format: "json" }).toString()).toEqual("/users/1/roles/2.json");
    });

    it("overrides the format when modifier method is called", function() {
      expect(Routes.loginPath({ format: "html" }).json().toString()).toEqual("/login.json");
      expect(Routes.userPath({ id: 1, format: "json" }).html().toString()).toEqual("/users/1.html");
      expect(Routes.userRolePath({ id: 1, role_id: 2, format: "json" }).html().toString()).toEqual("/users/1/roles/2.html");
    });
  });

  describe("specifying default format", function() {
    beforeEach(function() {
      Routes.initRoutes({
        "routes": {
          "login": "/login",
          "user": "/users/:id",
          "userRole": "/users/:id/roles/:role_id"
        },
        "format": "json"
      });
    });

    it("applies the default format to routes", function() {
      expect(Routes.loginPath().toString()).toEqual("/login.json");
      expect(Routes.userPath(1).toString()).toEqual("/users/1.json");
      expect(Routes.userRolePath(1, 2).toString()).toEqual("/users/1/roles/2.json");
    });

    it("allows overriding the default format", function() {
      expect(Routes.loginPath({ format: "html" }).toString()).toEqual("/login.html");
      expect(Routes.userPath({ format: "html", id: 1 }).toString()).toEqual("/users/1.html");
      expect(Routes.userRolePath({ format: "html", id: 1, role_id: 2 }).toString()).toEqual("/users/1/roles/2.html");
    });

    it("respects format modifiers", function() {
      expect(Routes.userPath({ id: 1, format: "html" }).xml().toString()).toEqual("/users/1.xml");
      expect(Routes.userPath(1).none().toString()).toEqual("/users/1");
    });
  });
});
