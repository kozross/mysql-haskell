{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import           Control.Concurrent.Async
import           Control.Monad
import           Data.Text (Text)
import           Data.Time.Calendar
import           Database.MySQL.Simple
import           System.Environment

main :: IO ()
main = do
    args <- getArgs
    case args of [threadNum] -> go (read threadNum)
                 _           -> putStrLn "No thread number provided."

go :: Int -> IO ()
go n = void . flip mapConcurrently [1..n] $ \ _ -> do
    c <- connect defaultConnectInfo { connectUser = "testMySQLHaskell"
                                    , connectDatabase = "testMySQLHaskell"
                                    }

    putStr "total rows: "
    (rs :: [(Int, Day, Text, Text, Text, Day)]) <- query_ c "SELECT * FROM employees"
    print (length rs)






