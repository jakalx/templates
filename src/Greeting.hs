module Greeting
  ( greet,
  )
where

greet :: String -> IO ()
greet = putStrLn
