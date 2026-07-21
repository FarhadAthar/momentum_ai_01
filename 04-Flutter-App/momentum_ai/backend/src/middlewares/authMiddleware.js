const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();

const protect = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      // 1. Token extract karein
      token = req.headers.authorization.split(" ")[1];

      // 2. Token verify karein
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // 3. User database mein dhoondein
      const user = await prisma.user.findUnique({
        where: { id: decoded.id },
        select: { id: true, name: true, email: true, role: true }, // Password exclude kiya
      });

      // 4. Agar user database mein nahi mila
      if (!user) {
        return res.status(401).json({ message: "User not found" });
      }

      // 5. User ko request object mein save karein
      req.user = user;

      // 🔥 IMPORTANT: return next() use kiya taake function yahin ruk jaye!
      return next();
    } catch (error) {
      // 🔥 Error par return lagana zaroori hai
      return res.status(401).json({ message: "Not authorized, token failed" });
    }
  }

  // 🔥 Agar request mein token hi nahi hai toh yahan return aayega
  if (!token) {
    return res.status(401).json({ message: "Not authorized, no token" });
  }
};

module.exports = { protect };
