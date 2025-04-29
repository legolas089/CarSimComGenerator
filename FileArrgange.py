import os
import shutil
import pandas as pd
import matplotlib.pyplot as plt
from datetime import datetime

# [1/5] Results 경로 설정
results_path = r"{Your_Path_To_CarSim}\Results"
print("📁 [1/5] Results 폴더 경로 설정 완료")

# [2/5] 최신 n개 폴더 탐색
n = 10
try:
    subfolders = [f.path for f in os.scandir(results_path) if f.is_dir()]
    subfolders.sort(key=lambda x: os.path.getmtime(x), reverse=True)
    latest_folders = subfolders[:n]
    print(f"📂 [2/5] 최신 폴더 n개 선택됨:\n" + "\n".join(latest_folders))
except Exception as e:
    print(f"❌ [2/5] 폴더 탐색 실패: {e}")
    latest_folders = []

# [3/5] Dataset 이름 추출 및 CSV 복사
copied_files = []
dataset_names = []
current_dir = os.getcwd()

for idx, folder in enumerate(latest_folders, 1):
    print(f"\n📌 [3/5-{idx}] 처리 중: {folder}")

    vs_path = os.path.join(folder, "LastRun.vs")
    dataset_name = "Unknown"

    if os.path.exists(vs_path):
        with open(vs_path, "r", encoding="utf-8") as f:
            for line in f:
                if '"Dataset"' in line:
                    dataset_name = line.split(":")[1].strip().strip('",')
                    print(f"🔍 Dataset 이름: {dataset_name}")
                    break
            else:
                print("⚠️ Dataset 키워드를 찾지 못함")
    else:
        print("⚠️ LastRun.vs 파일이 없음")
        continue

    csv_path = os.path.join(folder, "LastRun.csv")
    if os.path.exists(csv_path) and dataset_name != "Unknown":
        new_csv_name = f"{dataset_name}.csv"
        target_path = os.path.join(current_dir, new_csv_name)
        shutil.copy2(csv_path, target_path)
        copied_files.append(target_path)
        dataset_names.append(dataset_name)
        print(f"✅ CSV 복사 완료 → {new_csv_name}")
    else:
        print("⚠️ CSV 파일이 없거나 Dataset 이름을 알 수 없음")

# [4/5] CSV 파일 읽고 AVz를 모으기
if copied_files:
    print("\n📊 [4/5] AVz 데이터 모으는 중...")
    avz_data = []  # AVz 데이터 저장할 리스트
    time_data = None  # 시간은 하나만 저장

    for file in copied_files:
        try:
            df = pd.read_csv(file)
            if 'Time' in df.columns and 'AVz' in df.columns:
                if time_data is None:
                    time_data = df['Time'].values  # 시간은 첫 번째 파일 기준
                avz_data.append(df['AVz'].values)
            else:
                print(f"⚠️ {file}에 'Time' 또는 'AVz' 열이 없음")
        except Exception as e:
            print(f"❌ {file} 읽기 오류: {e}")

    # [5/5] AVz 데이터 저장 및 그래프 출력
    if avz_data and time_data is not None:
        # 테이블 생성
        avz_table = pd.DataFrame(avz_data).transpose()

        # 1행: 번호
        avz_table.columns = [str(i+1) for i in range(len(avz_data))]
        avz_table.loc[-2] = dataset_names  # 2행: 무게 이름
        avz_table.loc[-1] = avz_table.columns  # 1행: 번호 (이미 있음)
        avz_table = avz_table.sort_index()  # 인덱스 정렬해서 1행, 2행 순서 맞추기

        # 파일 저장
        today = datetime.now().strftime("%Y%m%d")
        save_name = f"{today}_{n}sims_AVZ.csv"
        avz_table.to_csv(save_name, index=False, header=False, encoding='utf-8-sig')

        print(f"✅ [5/5] AVz 테이블 저장 완료: {save_name}")

        # 그래프 그리기
        fig, ax = plt.subplots(figsize=(12, 8))
        for idx, avz in enumerate(avz_data):
            ax.plot(time_data, avz, label=dataset_names[idx])
        
        ax.set_title("Double Lane Change: Yaw Rate", fontsize=18)
        ax.set_xlabel("Time [s]", fontsize=16)
        ax.set_ylabel("Yaw Rate [deg/s]", fontsize=16)
        ax.tick_params(axis='x', labelsize=12)  # x축 tick 글씨 크기 조정
        ax.tick_params(axis='y', labelsize=12)  # y축 tick 글씨 크기 조정
        ax.grid(True)
        ax.legend(fontsize=12)
        plt.tight_layout()
        plt.show()
        print("✅ [5/5] 시각화 완료")
    else:
        print("❌ [5/5] AVz 데이터가 부족하여 시각화를 생략합니다.")
else:
    print("❌ [4/5] 복사된 CSV가 없어 시각화를 생략합니다.")
