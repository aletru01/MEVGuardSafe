// pages/success.tsx
import { useRouter } from 'next/router';

const SuccessPage = () => {
    const router = useRouter();
    const { nullifierHash } = router.query; // Retrieve the nullifierHash from query parameters
  
    return (
      <div className="flex flex-col items-center justify-center h-screen">
        <h1 className="text-3xl font-bold mb-4">Verification Successful</h1>
        <p className="text-xl">You have been successfully verified!</p>
        <p className="text-md mt-4">Thank you for verifying your identity with World ID.</p>
        {nullifierHash && <p className="text-md mt-4">Your Nullifier Hash: {nullifierHash}</p>}
        <a href="/" className="mt-8 text-blue-500 underline">
          Go back to home
        </a>
      </div>
    );
  };
  
  export default SuccessPage;