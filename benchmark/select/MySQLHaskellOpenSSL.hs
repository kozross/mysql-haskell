{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import           Control.Concurrent.Async
import           Control.Monad
import qualified Data.ByteString as B
import           Database.MySQL.Base hiding (connect, connectDetail)
import           Database.MySQL.OpenSSL
import           System.Environment
import           System.IO.Streams (fold)

main :: IO ()
main = do
    args <- getArgs
    case args of [threadNum] -> go (read threadNum)
                 _           -> putStrLn "No thread number provided."

go :: Int -> IO ()
go n = do
    ctx <- makeClientSSLContext (CustomCAStore "/usr/local/var/mysql/ca.pem")
    void . flip mapConcurrently [1..n] $ \ _ -> do
        c <- connect defaultConnectInfo { ciUser = "testMySQLHaskell"
                                        , ciDatabase = "testMySQLHaskell"
                                        }
                     (ctx, "MySQL")

        (fs, is) <- query_ c "SELECT * FROM employees"
        (rowCount :: Int) <- fold (\s _ -> s+1) 0 is
        putStr "field name: "
        forM_ fs $ \ f -> B.putStr (columnName f) >> B.putStr ", "
        putStr "\n"
        putStr "numbers of rows: "
        print rowCount






