import { VerificationLevel, IDKitWidget } from "@worldcoin/idkit";
import type { ISuccessResult } from "@worldcoin/idkit";
import type { VerifyReply } from "./api/verify";
import { useRouter } from "next/router";
import { useEffect, useRef } from "react";
import styles from '../styles/loggingPage.module.css';

export default function Home() {
	const openRef: any = useRef(null);

	if (!process.env.NEXT_PUBLIC_WLD_APP_ID) {
		throw new Error("app_id is not set in environment variables!");
	}
	if (!process.env.NEXT_PUBLIC_WLD_ACTION) {
		throw new Error("app_id is not set in environment variables!");
	}

	const router = useRouter();
	useEffect(() => {

		if (openRef.current) {
			openRef.current();
		}
	}, []);

	const onSuccess = (result: ISuccessResult) => {
		// This is where you should perform frontend actions once a user has been verified, such as redirecting to a new page
		window.alert("Successfully verified with World ID! Your nullifier hash is: " + result.nullifier_hash);
	};

	const handleProof = async (result: ISuccessResult) => {
		console.log("Proof received from IDKit:\n", JSON.stringify(result)); // Log the proof from IDKit to the console for visibility
		const reqBody = {
			merkle_root: result.merkle_root,
			nullifier_hash: result.nullifier_hash,
			proof: result.proof,
			verification_level: result.verification_level,
			action: process.env.NEXT_PUBLIC_WLD_ACTION,
			signal: "",
		};

		console.log("Sending proof to backend for verification:\n", JSON.stringify(reqBody)) // Log the proof being sent to our backend for visibility
		const res: Response = await fetch("/api/verify", {
			method: "POST",
			headers: {
				"Content-Type": "application/json",
			},
			body: JSON.stringify(reqBody),
		})
		const data: VerifyReply = await res.json()
		if (res.status == 200) {
			console.log("Successful response from backend:\n", data); // Log the response from our backend for visibility
			console.log("hash: ", result.nullifier_hash);
			const nullifierHash = result.nullifier_hash;
			router.push({
				pathname: '/loggedPage',
				query: { nullifierHash },
			});
		} else {
			throw new Error(`Error code ${res.status} (${data.code}): ${data.detail}` ?? "Unknown error."); // Throw an error if verification fails
		}
	};

	return (
		<div className={styles.container}>
			<IDKitWidget
				action={process.env.NEXT_PUBLIC_WLD_ACTION!}
				app_id={process.env.NEXT_PUBLIC_WLD_APP_ID as `app_${string}`}
				onSuccess={onSuccess}
				handleVerify={handleProof}
				verification_level={VerificationLevel.Device} // Change this to VerificationLevel.Device to accept Orb- and Device-verified users
			>
				{({ open }) => {
					openRef.current = open;
					return <></>;
				}}
			</IDKitWidget>
		</div>
	);
}
