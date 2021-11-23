import Data.Int
import Foreign.Ptr
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array
import Foreign.Storable

data Futhark_Context_Config
foreign import ccall "futhark_context_config_new"
  futhark_context_config_new :: IO (Ptr Futhark_Context_Config)

data Futhark_Context
foreign import ccall "futhark_context_new"
  futhark_context_new :: Ptr Futhark_Context_Config -> IO (Ptr Futhark_Context)

data Futhark_i32_1d
foreign import ccall "futhark_new_i32_1d"
  futhark_new_i32_1d :: Ptr Futhark_Context -> Ptr Int32
                     -> Int32 -> IO (Ptr Futhark_i32_1d)

foreign import ccall "futhark_entry_dotprod"
  futhark_entry_dotprod :: Ptr Futhark_Context -> Ptr Int32
                        -> Ptr Futhark_i32_1d -> Ptr Futhark_i32_1d -> IO ()

main :: IO ()
main = do
  cfg <- futhark_context_config_new
  ctx <- futhark_context_new cfg

  x <- newArray [1,2,3,4]
  y <- newArray [2,3,4,1]

  x_arr <- futhark_new_i32_1d ctx x 4
  y_arr <- futhark_new_i32_1d ctx y 4

  res <- alloca $ \res -> do futhark_entry_dotprod ctx res x_arr y_arr
                             peek res
  putStrLn $ "Result: " ++ show res
