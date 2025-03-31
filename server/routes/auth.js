const express =require('express');
const authRouter=express.Router();
const User=require('../models/user');
const jwt=require('jsonwebtoken');
const auth = require('../middleware/auth');
authRouter.post('/api/signup', async(req,res)=>{
    try{
    
      
    const {name,email,profilePic}=req.body;
  let user=await User.findOne({email});
  if(!user){
user=new User({email,profilePic,name})    ;
    user=await user.save();


  }
 const token= jwt.sign({id:user._id},"passwordKey");
   res.json({user,token});
    }catch(error){
        console.log("Error",error);
        res.status(500).json({error:error.message});
    }
});
authRouter.get('/',auth,async (req,res)=>{
  const user =await User.findById(req.user);
  res.json({user,token:req.token});
});
module.exports=authRouter;