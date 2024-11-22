#!/bin/bash

# تعيين الألوان للإخراج
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# إنشاء مجلد مؤقت للنتائج
TEMP_DIR="/tmp/pkg_extract"
RESULT_FILE="$HOME/installed_packages_full.txt"
LOG_FILE="$HOME/pkg_extract.log"

# وظيفة لعرض الرسائل
show_message() {
    echo -e "${BLUE}[$(date '+%H:%M:%S')]${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# وظيفة لعرض التقدم
show_progress() {
    echo -ne "${YELLOW}$1${NC}\r"
}

# إنشاء المجلدات المطلوبة
show_message "إنشاء المجلدات المطلوبة..."
mkdir -p "$TEMP_DIR"

# تهيئة الملفات
echo "بدء استخراج الحزم $(date)" > "$LOG_FILE"
echo "=============================" >> "$LOG_FILE"

# وظيفة للبحث عن الحزم من ملفات PKGINFO
find_pkginfo_packages() {
    show_message "بدء البحث عن ملفات PKGINFO..."
    local count=0
    local total=$(find / -type f -name "PKGINFO" 2>/dev/null | wc -l)
    
    find / -type f -name "PKGINFO" 2>/dev/null | while read -r file; do
        ((count++))
        show_progress "معالجة PKGINFO: $count من $total"
        
        pkg_name=$(grep "^pkgname = " "$file" 2>/dev/null | cut -d= -f2 | tr -d ' ')
        pkg_version=$(grep "^pkgver = " "$file" 2>/dev/null | cut -d= -f2 | tr -d ' ')
        if [ ! -z "$pkg_name" ]; then
            echo "$pkg_name ${pkg_version:-unknown}" >> "$TEMP_DIR/pkginfo_packages.txt"
        fi
    done
    echo -e "\n" # مسافة جديدة بعد شريط التقدم
}

# وظيفة للبحث عن الحزم من مجلد /usr/share
find_usr_share_packages() {
    show_message "بدء البحث في /usr/share..."
    local count=0
    
    find /usr/share/doc /usr/share/packages -maxdepth 1 -type d 2>/dev/null | \
    while read -r dir; do
        ((count++))
        show_progress "معالجة /usr/share: $count حزمة"
        basename "$dir" >> "$TEMP_DIR/usr_share_packages.txt"
    done
    echo -e "\n"
}

# وظيفة للبحث عن الحزم من مجلد /etc
find_etc_packages() {
    show_message "بدء البحث في /etc..."
    local count=0
    
    find /etc/*/pkg/* /etc/*/*.pacnew /etc/*/*.pacsave 2>/dev/null | \
    while read -r file; do
        ((count++))
        show_progress "معالجة /etc: $count حزمة"
        basename "$file" | sed 's/\.pac\(new\|save\)$//' >> "$TEMP_DIR/etc_packages.txt"
    done
    echo -e "\n"
}

# وظيفة لجمع النتائج
collect_results() {
    show_message "جمع النتائج النهائية..."
    echo "# قائمة الحزم المثبتة - تم إنشاؤها في $(date)" > "$RESULT_FILE"
    echo "# =====================================" >> "$RESULT_FILE"
    
    for file in "$TEMP_DIR"/*.txt; do
        if [ -f "$file" ]; then
            show_message "دمج $(basename "$file")..."
            sort -u "$file" >> "$RESULT_FILE"
        fi
    done
    
    local total_packages=$(sort -u -o "$RESULT_FILE" "$RESULT_FILE" && wc -l < "$RESULT_FILE")
    show_message "تم العثور على ${GREEN}$total_packages${NC} حزمة مثبتة بشكل إجمالي"
}

# التنفيذ الرئيسي
show_message "بدء عملية استخراج الحزم..."
find_pkginfo_packages
find_usr_share_packages
find_etc_packages
collect_results

# تنظيف
show_message "تنظيف الملفات المؤقتة..."
rm -rf "$TEMP_DIR"

show_message "${GREEN}اكتمل الاستخراج بنجاح!${NC}"
echo -e "${BLUE}النتائج محفوظة في:${NC} $RESULT_FILE"
echo -e "${BLUE}سجل العمليات في:${NC} $LOG_FILE"
