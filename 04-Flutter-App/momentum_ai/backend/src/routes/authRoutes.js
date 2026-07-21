const express = require("express");
const router = express.Router();
// 👇 Controller import karein (jo hum agle step mein banayenge)
const { registerUser, loginUser } = require("../controllers/authController");

// Routes define karein
router.post("/signup", registerUser);
router.post("/login", loginUser);

// Router ko export karna na bhoolen
module.exports = router;
